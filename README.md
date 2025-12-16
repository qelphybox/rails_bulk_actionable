# Bulk Actionable - Rails Concern Showcase

A Rails concern that enables bulk selection and actions across paginated collections. Selected items are persisted in cache, allowing users to select items across multiple pages and perform batch operations.

## Demo

https://bulkactionable.qelphybox.space/

## Features

- ✅ **Multi-page selection** - Select items across paginated views
- ✅ **Persistent selection** - Selected items stored in Rails cache with session isolation
- ✅ **Group support** - Separate selections for different contexts
- ✅ **Stimulus integration** - Modern JavaScript controller for seamless UX
- ✅ **Flexible actions** - Easy to implement custom bulk operations

## How It Works

The `BulkActionable` concern provides a complete solution for managing bulk selections:

1. **Backend (Rails Concern)**: Manages selection state in Rails cache, scoped by session and controller
2. **Frontend (Stimulus Controller)**: Handles checkbox interactions and UI state
3. **Routes**: RESTful endpoints for selection operations

Selected item IDs are stored in cache using a session-scoped key, allowing selections to persist across page navigation while maintaining isolation between different users and controllers.

## Usage Example

### 1. Include the Concern

```ruby
class PeopleController < ApplicationController
  include BulkActionable

  private

  def bulk_action_scope
    Person.all
  end

  def bulk_action_id_param
    :id  # or :uuid, or any identifier column
  end
end
```

### 2. Add Routes

```ruby
Rails.application.routes.draw do
  concern :bulk_actionable do
    post :bulk_action_check, on: :collection
    post :bulk_action_uncheck, on: :collection
    post :bulk_action_check_all, on: :collection
    post :bulk_action_uncheck_all, on: :collection
  end

  resources :people, concerns: :bulk_actionable do
    delete :bulk_destroy, on: :collection
  end
end
```

### 3. Implement Bulk Actions

```ruby
def bulk_destroy
  bulk_action_selected_items.find_each(&:destroy!)
  bulk_action_reset
  
  redirect_to people_path, notice: "Selected items destroyed."
end
```

### 4. Setup View

```erb
<div
  data-controller="bulk-actionable"
  data-bulk-actionable-controller-path-value="<%= people_path %>"
  data-bulk-actionable-total-items-value="<%= bulk_action_total_items %>"
  data-bulk-actionable-selected-items-value="<%= bulk_action_item_ids.to_a.to_json %>">

  <!-- Main checkbox for page selection -->
  <input
    type="checkbox"
    data-bulk-actionable-target="mainCheckbox"
    data-action="click->bulk-actionable#toggleMainCheckbox">

  <!-- Action toolbar (shown when items selected) -->
  <div data-bulk-actionable-target="hideWhenSelected">
    <%= button_to bulk_destroy_people_path, method: :delete, 
          class: "btn btn-danger" do %>
      Delete Selected
    <% end %>
  </div>

  <!-- Individual item checkboxes -->
  <% @people.each do |person| %>
    <input
      type="checkbox"
      data-bulk-actionable-target="itemCheckbox"
      data-id="<%= person.id %>"
      data-action="click->bulk-actionable#toggleItemCheckbox">
  <% end %>
</div>
```

## Available Methods

### Controller Helpers

- `bulk_action_item_ids` - Returns Set of selected item IDs
- `bulk_action_total_items` - Total count of items in scope
- `bulk_action_selected_items` - ActiveRecord relation of selected items
- `bulk_action_reset` - Clear all selections

### API Endpoints

- `POST /resource/bulk_action_check` - Add items to selection
- `POST /resource/bulk_action_uncheck` - Remove items from selection
- `POST /resource/bulk_action_check_all` - Select all items in scope
- `POST /resource/bulk_action_uncheck_all` - Clear all selections

## Advanced: Group Support

Use groups to maintain separate selections for different contexts:

```ruby
class ProductsController < ApplicationController
  include BulkActionable

  before_action :set_bulk_action_group

  private

  def set_bulk_action_group
    self.bulk_action_group = params[:group] # e.g., :active, :archived
  end
end
```

## Architecture

- **Storage**: Rails cache with session-scoped keys
- **Isolation**: Each user session has independent selections
- **Scope**: Selections are scoped per controller (and optionally per group)
- **Frontend**: Stimulus controller handles all UI interactions
- **Backend**: RESTful JSON API for selection management

## Example Use Cases

- Bulk delete operations
- Batch status updates
- Mass export/import
- Multi-select workflows
- Administrative bulk actions

---

This is a showcase project demonstrating the `BulkActionable` concern functionality. See `app/controllers/people_controller.rb` and `app/views/people/index.html.erb` for complete implementation examples.
