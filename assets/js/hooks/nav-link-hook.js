function getActive(href, exact) {
  const path = window.location.pathname;
  const hrefPathname = new URL(href).pathname;
  if (exact === "true") {
    return hrefPathname === path;
  } else {
    return path.startsWith(hrefPathname);
  }
}

const createActiveLinkListner = (el) => () => {
  const exact = el.dataset.exact;
  const activeClass = el.dataset.activeClass ?? "active";
  const active = getActive(el.href, exact);
  if (active) {
    el.classList.add(activeClass);
  } else {
    el.classList.remove(activeClass);
  }
};

let listener = null;

export const NavLink = {
  mounted() {
    listener = createActiveLinkListner(this.el);
    window.addEventListener("phx:page-loading-stop", listener);
    listener();
  },
  destroyed() {
    if (listener) {
      window.removeEventListener("phx:page-loading-stop", listener);
      listener = null;
    }
  },
};
