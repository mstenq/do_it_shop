const localStorageKey = "do-it-shop-theme";

function getInitialTheme() {
  const persistedColorPreference = window.localStorage.getItem(localStorageKey);
  const hasPersistedPreference = typeof persistedColorPreference === "string";

  if (hasPersistedPreference) {
    return persistedColorPreference;
  }

  // If there is no saved preference, use a media query
  const mql = window.matchMedia("(prefers-color-scheme: dark)");
  const hasMediaQueryPreference = typeof mql.matches === "boolean";

  if (hasMediaQueryPreference) {
    return mql.matches ? "dark" : "light";
  }

  // If there is no preference, use the default
  return "light";
}

function toggleTheme() {
  const html = document.querySelector("html");
  html.classList.toggle("light");
  html.classList.toggle("dark");
  const currentMode = html.classList.contains("dark") ? "dark" : "light";
  html.dataset.theme = currentMode;
  localStorage.setItem(localStorageKey, currentMode);
}

export const ThemeToggle = {
  mounted() {
    const currentTheme = getInitialTheme();
    if (currentTheme === "dark") {
      toggleTheme();
      this.el.checked = true;
    }
    this.el.addEventListener("click", toggleTheme);
  },
  destroyed() {
    this.el.removeEventListener("click", toggleTheme);
  },
};
