function getSortParamsFromURL() {
  const params = new URLSearchParams(window.location.search);
  console.log(params);
  const current_sort_by = params.get("sort_by") ?? "";
  const current_sort_order = params.get("sort_order") ?? "";

  return {
    current_sort_by,
    current_sort_order,
  };
}

function syncDataAttributes(el) {
  const { current_sort_by, current_sort_order } = getSortParamsFromURL();
  const sort_by = el.dataset?.sortBy;

  // inform the element if it is currently being sorted by this attribute
  if (sort_by === current_sort_by) {
    el.dataset.isCurrentSort = true;
  } else {
    el.dataset.isCurrentSort = false;
  }

  // inform the element of current sort order
  el.dataset.sortOrder = current_sort_order;
}

export const SortParams = {
  mounted() {
    syncDataAttributes(this.el);
  },
  updated() {
    setTimeout(() => {
      syncDataAttributes(this.el);
    }, 0);
  },
};
