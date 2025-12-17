import { Controller } from "@hotwired/stimulus"
import { post } from 'helpers/request_helper';

export default class extends Controller {
  static targets = ["mainCheckbox", "itemCheckbox", "hideWhenSelected", "showWhenSelected", "selectedCount"];

  static values = {
    totalItems: Number,
    selectedItems: Array,
    controllerPath: String
  };

  connect() {
    this.#renderToolbarVisibility();
  }

  get currentPageItems() {
    return this.itemCheckboxTargets.map(item => Number(item.dataset.id));
  }

  get currentPageSelectedItems() {
    return this.itemCheckboxTargets.filter(item => item.checked);
  }

  itemCheckboxTargetConnected(element) {
    if (this.selectedItemsValue.includes(Number(element.dataset.id))) {
      element.checked = true;
    } else {
      element.checked = false;
    }
  }

  mainCheckboxTargetConnected() {
    this.#renderMainCheckbox();
  }

  async selectAll() {
    await this.#sendSelection(this.currentPageItems, "check_all");
    location.reload();
  }

  async unselectAll() {
    await this.#sendSelection(this.currentPageItems, "uncheck_all");
    location.reload();
  }

  async toggleMainCheckbox(event) {
    const element = event.currentTarget;

    this.itemCheckboxTargets.forEach(item => { item.checked = element.checked });    
    this.#updateSelectedItems(this.currentPageItems, element.checked);
    this.#renderToolbarVisibility();
    this.#renderSelectedCount();
    
    if (element.checked) {
      await this.#sendSelection(this.currentPageItems, "check");
    } else {
      await this.#sendSelection(this.currentPageItems, "uncheck");
    }  
  }

  async toggleItemCheckbox(event) {
    const element = event.currentTarget;
    this.#updateSelectedItems([Number(element.dataset.id)], element.checked);
    this.#renderMainCheckbox();
    this.#renderToolbarVisibility();
    this.#renderSelectedCount();

    if (event.currentTarget.checked) {
      await this.#sendSelection([Number(event.currentTarget.dataset.id)], "check");
    } else {
      await this.#sendSelection([Number(event.currentTarget.dataset.id)], "uncheck");
    }
  }

  async #sendSelection(itemIds, action) {
    const controllerAction = `bulk_action_${action}`;
    const requestParams = ["check_all", "uncheck_all"].includes(action) ? {} : { id: itemIds };

    try {
      const { selected } = await post(`${this.controllerPathValue}/${controllerAction}`, requestParams);
      this.selectedItemsValue = selected;
    } catch (error) {
      console.error('[bulk_actionable]', error);
      alert("Failed to update bulk action selection");
      location.reload();
    }
  }

  #updateSelectedItems(itemIds, checked) {
    if (checked) {
      this.selectedItemsValue = this.selectedItemsValue.concat(itemIds);
    } else {
      this.selectedItemsValue = this.selectedItemsValue.filter(item => !itemIds.includes(item));
    }
  }

  #renderToolbarVisibility() {
    const hasSelection = this.selectedItemsValue.length > 0;
    
    if (hasSelection) {
      this.hideWhenSelectedTarget.classList.add("d-none");
      this.showWhenSelectedTarget.classList.remove("d-none");
    } else {
      this.hideWhenSelectedTarget.classList.remove("d-none");
      this.showWhenSelectedTarget.classList.add("d-none");
    }
  }

  #renderMainCheckbox() {
    const selectedCount = new Set(this.selectedItemsValue).intersection(new Set(this.currentPageItems)).size; 
    const totalCount = this.currentPageItems.length;

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

  #renderSelectedCount() {
    this.selectedCountTarget.textContent = this.selectedItemsValue.length;
  }
}
