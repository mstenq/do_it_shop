import SortableJS from "sortablejs";

export const Sortable = {
  mounted() {
    const group = this.el.dataset.group;
    let isDragging = false;
    this.el.addEventListener(
      "focusout",
      (e) => isDragging && e.stopImmediatePropagation()
    );
    let sorter = new SortableJS(this.el, {
      group: group ? { name: group, pull: true, put: true } : undefined,
      animation: 150,
      dragClass: "drag-item",
      ghostClass: "drag-ghost",
      onStart: (e) => (isDragging = true), // prevent phx-blur from firing while dragging
      onEnd: (e) => {
        isDragging = false;
        let params = {
          old: e.oldIndex,
          new: e.newIndex,
          to: e.to.dataset,
          ...e.item.dataset,
        };
        this.pushEventTo(
          this.el,
          this.el.dataset["drop"] || "reposition",
          params
        );
      },
    });
  },
};
