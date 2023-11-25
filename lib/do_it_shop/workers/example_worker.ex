defmodule DoItShop.Workers.ExampleWorker do
  use Oban.Worker, queue: :default

  @impl true
  def perform(%Oban.Job{args: args}) do
    # Do some work
    IO.puts("Hello world!")
    :ok
  end
end
