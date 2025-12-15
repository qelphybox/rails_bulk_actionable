import { Controller } from "@hotwired/stimulus"
import { post } from 'helpers/request_helper';


// Connects to data-controller="bulk-actionable"
export default class extends Controller {
  static targets = ["mainCheckbox", "itemCheckbox", "hideWhenSelected", "showWhenSelected"];

  static values = {
    totalItems: Number,
    selectedItems: Array,
    controllerPath: String
  };

  connect() {
    this.#updateToolbarVisibility();
  }

  get currentPageItems() {
    return this.itemCheckboxTargets.map(item => Number(item.dataset.id));
  }

  get currentPageSelectedItems() {
    const selectedItemsSet = new Set(this.selectedItemsValue)
    const currentPageItemsSet = new Set(this.currentPageItems)
    return Array.from(selectedItemsSet.intersection(currentPageItemsSet))
  }

  itemCheckboxTargetConnected(element) {
    if (this.selectedItemsValue.includes(Number(element.dataset.id))) {
      element.checked = true;
    } else {
      element.checked = false;
    }
  }

  mainCheckboxTargetConnected() {
    this.#updateMainCheckbox(this.currentPageSelectedItems.length, this.totalItemsValue);
  }

  async selectAll() {
    await this.#sendSelection(this.currentPageItems, "check_all");
    this.#updateMainCheckbox();
    this.#updateToolbarVisibility();
  }

  async unselectAll() {
    await this.#sendSelection(this.currentPageItems, "uncheck_all");
    this.#updateMainCheckbox();
    this.#updateToolbarVisibility();
  }

  async toggleMainCheckbox(event) {
    const element = event.currentTarget;

    if (element.checked) {
      await this.#sendSelection(this.currentPageItems, "check");
    } else {
      await this.#sendSelection(this.currentPageItems, "uncheck");
    }

    this.#updateMainCheckbox();
    this.#updateToolbarVisibility();
  }

  async toggleItemCheckbox(event) {
    if (event.currentTarget.checked) {
      await this.#sendSelection([Number(event.currentTarget.dataset.id)], "check");
    } else {
      await this.#sendSelection([Number(event.currentTarget.dataset.id)], "uncheck");
    }

    this.#updateMainCheckbox();
    this.#updateToolbarVisibility();
  }

  // action - check, uncheck, check_all, uncheck_all
  async #sendSelection(itemIds, action) {
    const controllerAction = `bulk_action_${action}`;
    const requestParams = ["check_all", "uncheck_all"].includes(action) ? {} : { id: itemIds };

    try {
      const { selected } = await post(`${this.controllerPathValue}/${controllerAction}`, requestParams);
      this.selectedItemsValue = selected;
    } catch (error) {
      console.error('[bulk_actionable]', error);
      alert("Failed to update bulk action selection");
    }
  }

  #updateToolbarVisibility() {
    const hasSelection = this.selectedItemsValue.length > 0;

    if (hasSelection) {
      this.hideWhenSelectedTarget.classList.remove("d-none");
      this.showWhenSelectedTarget.classList.add("d-none");
    } else {
      this.hideWhenSelectedTarget.classList.add("d-none");
      this.showWhenSelectedTarget.classList.remove("d-none");
    }
  }

  #updateMainCheckbox() {
    const selectedCount = this.currentPageSelectedItems.length;
    const totalCount = this.totalItemsValue;

    if (selectedCount === 0) {
      this.mainCheckboxTarget.checked = false;
      this.mainCheckboxTarget.indeterminate = false;
    } else if (selectedCount < totalCount) {
      this.mainCheckboxTarget.checked = true;
      this.mainCheckboxTarget.indeterminate = true;
    } else {
      this.mainCheckboxTarget.indeterminate = false;
      this.mainCheckboxTarget.checked = true;
    }
  }
}
