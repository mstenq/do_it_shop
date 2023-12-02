import scrollSpy from "simple-scrollspy";

let timer = null;

const options = {
  sectionClass: ".scrollspy",
  menuActiveTarget: ".menu-item",
  offset: 320,
  scrollContainer: ".main-content",
  onActive: (el) => {
    if (timer) clearTimeout(timer);
    timer = setTimeout(() => {
      const scrollIndicator = document.querySelector("#scroll-indicator");
      scrollIndicator.style.width = `${el.offsetWidth}px`;
      scrollIndicator.style.left = `${el.offsetLeft}px`;
    }, 190);
  },
};

export const ScrollSpy = {
  mounted() {
    console.log("ScrollSpy mounted", this.el);
    scrollSpy(this.el, options);
  },
  updated() {},
  destroyed() {},
};
