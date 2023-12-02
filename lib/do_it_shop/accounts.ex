defmodule DoItShop.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias DoItShop.Utils.Sort
  alias DoItShop.Tenants.Role
  alias DoItShop.Repo

  alias DoItShop.Accounts.{User, UserToken, UserNotifier}
  alias DoItShop.Tenants

  def get_topic do
    inspect(__MODULE__) <> "." <> Integer.to_string(DoItShop.Store.get_org_id())
  end

  def subscribe do
    topic = get_topic()
    Phoenix.PubSub.subscribe(DoItShop.PubSub, topic)
  end

  @doc """
  tags: [:user_created]
  todo: need to implement [:user_updated, :user_deleted]
  """
  def broadcast({:ok, user}, tag) do
    Phoenix.PubSub.broadcast(DoItShop.PubSub, get_topic(), {tag, user})
    {:ok, user}
  end

  def broadcast(_, _tag) do
    :error
  end

  ## Database getters

  @doc """
  Gets a user by email.
  
  ## Examples
  
      iex> get_user_by_email("foo@example.com")
      %User{}
  
      iex> get_user_by_email("unknown@example.com")
      nil
  
  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a user by email and password.
  
  ## Examples
  
      iex> get_user_by_email_and_password("foo@example.com", "correct_password")
      %User{}
  
      iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
      nil
  
  """
  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, [email: email], skip_org_id: true)

    if User.valid_password?(user, password), do: user
  end

  @doc """
  Gets a single user.
  
  Raises `Ecto.NoResultsError` if the User does not exist.
  
  ## Examples
  
      iex> get_user!(123)
      %User{}
  
      iex> get_user!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_user!(id, opts \\ []) do
    IO.inspect(opts, label: "GET USER OPTS", pretty: true)
    Repo.get!(User, id, opts) |> Repo.preload([:role, :org])
  end

  def broadcast_user({:ok, user}, tag) do
    broadcast({:ok, get_user!(user.id, skip_org_id: true)}, tag)
  end

  def broadcast_user(_, _tag) do
    :error
  end

  ## User registration

  @doc """
  Registers a user.
  
  ## Examples
  
      iex> register_user(%{field: value})
      {:ok, %User{}}
  
      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def register_user(attrs) do
    case Tenants.create_org(attrs) do
      {:ok, org, owner_role} ->
        user_attr = Map.merge(attrs, %{"org_id" => org.org_id, "role_id" => owner_role.id})

        {:ok, user} =
          %User{}
          |> User.registration_changeset(user_attr)
          |> Repo.insert()
          |> broadcast_user(:user_created)

        # TODO - Put Current User.
        DoItShop.Repo.put_org_id(org.org_id)
        {:ok, user}

      {:error, _} ->
        {:error, %Ecto.Changeset{}}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  
  ## Examples
  
      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}
  
  """
  def change_user_registration(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs, hash_password: false, validate_email: false)
  end

  def add_user_to_org(attrs) do
    org_id = DoItShop.store().get_org_id()
    temporary_password = "temporary_password"

    user_attrs =
      Map.merge(attrs, %{
        "org_id" => org_id,
        "password" => temporary_password,
        "company_name" => "I suck at coding"
      })

    %User{}
    |> User.registration_changeset(user_attrs)
    |> Repo.insert()
    |> broadcast_user(:user_created)
  end

  def change_user_add_to_org(%User{} = user, attrs \\ %{}) do
    User.add_user_changeset(user, attrs)
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user email.
  
  ## Examples
  
      iex> change_user_email(user)
      %Ecto.Changeset{data: %User{}}
  
  """
  def change_user_email(user, attrs \\ %{}) do
    User.email_changeset(user, attrs, validate_email: false)
  end

  @doc """
  Emulates that the email will change without actually changing
  it in the database.
  
  ## Examples
  
      iex> apply_user_email(user, "valid password", %{email: ...})
      {:ok, %User{}}
  
      iex> apply_user_email(user, "invalid password", %{email: ...})
      {:error, %Ecto.Changeset{}}
  
  """
  def apply_user_email(user, password, attrs) do
    user
    |> User.email_changeset(attrs)
    |> User.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates the user email using the given token.
  
  If the token matches, the user email is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  def update_user_email(user, token) do
    context = "change:#{user.email}"

    with {:ok, query} <- UserToken.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Repo.one(query, skip_org_id: true),
         {:ok, _} <- Repo.transaction(user_email_multi(user, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp user_email_multi(user, email, context) do
    changeset =
      user
      |> User.email_changeset(%{email: email})
      |> User.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, [context]))
  end

  @doc ~S"""
  Delivers the update email instructions to the given user.
  
  ## Examples
  
      iex> deliver_user_update_email_instructions(user, current_email, &url(~p"/users/settings/confirm_email/#{&1})")
      {:ok, %{to: ..., body: ...}}
  
  """
  def deliver_user_update_email_instructions(%User{} = user, current_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "change:#{current_email}")

    Repo.insert!(user_token)
    UserNotifier.deliver_update_email_instructions(user, update_email_url_fun.(encoded_token))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user password.
  
  ## Examples
  
      iex> change_user_password(user)
      %Ecto.Changeset{data: %User{}}
  
  """
  def change_user_password(user, attrs \\ %{}) do
    User.password_changeset(user, attrs, hash_password: false)
  end

  @doc """
  Updates the user password.
  
  ## Examples
  
      iex> update_user_password(user, "valid password", %{password: ...})
      {:ok, %User{}}
  
      iex> update_user_password(user, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_user_password(user, password, attrs) do
    changeset =
      user
      |> User.password_changeset(attrs)
      |> User.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, :all),
      skip_org_id: true
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query, skip_org_id: true)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_user_session_token(token) do
    Repo.delete_all(UserToken.by_token_and_context_query(token, "session"), skip_org_id: true)
    :ok
  end

  ## Confirmation

  @doc ~S"""
  Delivers the confirmation email instructions to the given user.
  
  ## Examples
  
      iex> deliver_user_confirmation_instructions(user, &url(~p"/users/confirm/#{&1}"))
      {:ok, %{to: ..., body: ...}}
  
      iex> deliver_user_confirmation_instructions(confirmed_user, &url(~p"/users/confirm/#{&1}"))
      {:error, :already_confirmed}
  
  """
  def deliver_user_confirmation_instructions(%User{} = user, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    if user.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, user_token} = UserToken.build_email_token(user, "confirm")
      Repo.insert!(user_token, repo_opts: [skip_org_id: true])
      UserNotifier.deliver_confirmation_instructions(user, confirmation_url_fun.(encoded_token))
    end
  end

  def deliver_user_new_account_instructions(%User{} = user, reset_url_fun) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "reset_password")
    Repo.insert!(user_token, repo_opts: [skip_org_id: true])
    UserNotifier.deliver_new_account_instructions(user, reset_url_fun.(encoded_token))
  end

  @doc """
  Confirms a user by the given token.
  
  If the token matches, the user account is marked as confirmed
  and the token is deleted.
  """
  def confirm_user(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "confirm"),
         %User{} = user <- Repo.one(query),
         {:ok, %{user: user}} <- Repo.transaction(confirm_user_multi(user)) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  defp confirm_user_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.confirm_changeset(user))
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, ["confirm"]))
  end

  ## Reset password

  @doc ~S"""
  Delivers the reset password email to the given user.
  
  ## Examples
  
      iex> deliver_user_reset_password_instructions(user, &url(~p"/users/reset_password/#{&1}"))
      {:ok, %{to: ..., body: ...}}
  
  """
  def deliver_user_reset_password_instructions(%User{} = user, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "reset_password")
    Repo.insert!(user_token)
    UserNotifier.deliver_reset_password_instructions(user, reset_password_url_fun.(encoded_token))
  end

  @doc """
  Gets the user by reset password token.
  
  ## Examples
  
      iex> get_user_by_reset_password_token("validtoken")
      %User{}
  
      iex> get_user_by_reset_password_token("invalidtoken")
      nil
  
  """
  def get_user_by_reset_password_token(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "reset_password"),
         %User{} = user <- Repo.one(query, skip_org_id: true) do
      user
    else
      _ -> nil
    end
  end

  @doc """
  Resets the user password.
  
  ## Examples
  
      iex> reset_user_password(user, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %User{}}
  
      iex> reset_user_password(user, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}
  
  """
  def reset_user_password(user, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.password_changeset(user, attrs), skip_org_id: true)
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, :all),
      skip_org_id: true
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  @default_sort :first_name
  @allowed ~w(id first_name last_name email role)

  def list_users(params \\ %{}) do
    overrides = %{
      role: dynamic([_u, r], r.role)
    }

    users =
      User
      |> join(:inner, [u], r in Role, on: u.role_id == r.id)
      |> preload([:role, :org])
      |> search(params)
      |> limit(10)
      |> Sort.sort(params, @default_sort, @allowed, overrides)
      |> Repo.all()

    IO.inspect(users, label: "users results")

    users
  end

  defp search(query, %{"search" => search}) do
    search = String.trim(search) |> String.split() |> Enum.join(" & ")
    search_term = "#{search}:*"

    case String.length(search) > 2 do
      true ->
        query
        |> where(fragment("searchable @@ to_tsquery(?)", ^search_term))
        |> order_by(
          desc: fragment("ts_rank_cd(searchable, websearch_to_tsquery(?), 4)", ^search_term)
        )

      false ->
        query
    end
  end

  defp search(query, _params), do: query
end
