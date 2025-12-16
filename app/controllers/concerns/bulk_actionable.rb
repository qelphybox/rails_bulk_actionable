module BulkActionable
  extend ActiveSupport::Concern

  included do
    helper_method :bulk_action_item_ids, :bulk_action_total_items, :bulk_action_selected_items

    def bulk_action_check
      return head(:not_found) if bulk_action_params_item_ids.blank?

      bulk_action_append_item_ids(bulk_action_params_item_ids)
      render json: { selected: bulk_action_item_ids.to_a }
    end

    def bulk_action_uncheck
      return head(:not_found) if bulk_action_params_item_ids.blank?

      bulk_action_remove_item_ids(bulk_action_params_item_ids)
      render json: { selected: bulk_action_item_ids.to_a }
    end

    def bulk_action_check_all
      all_ids = bulk_action_scope.pluck(bulk_action_id_param).uniq
      bulk_action_append_item_ids(all_ids)

      render json: { selected: bulk_action_item_ids.to_a }
    end

    def bulk_action_uncheck_all
      bulk_action_reset

      render json: { selected: bulk_action_item_ids.to_a }
    end

    def bulk_action_group
      @bulk_action_group ||= params[:group].presence&.to_sym
    end

    def bulk_action_group=(value)
      @bulk_action_group = value.to_sym
    end

    private

    def bulk_action_session_key
      session[:bulk_action_session_key] ||= SecureRandom.uuid
      key = "#{session[:bulk_action_session_key]}__#{controller_path}__bulk_action_item_ids"
      key = "#{bulk_action_group}__#{key}" if bulk_action_group.present?
      key
    end

    def bulk_action_scope
      raise NotImplementedError
    end

    def bulk_action_id_param
      :uuid
    end

    def bulk_action_total_items
      bulk_action_scope.count
    end

    def bulk_action_selected_items
      @bulk_action_selected_items ||=
        bulk_action_scope.where(bulk_action_id_param => bulk_action_item_ids)
    end

    def bulk_action_params_item_ids
      @bulk_action_params_item_ids ||=
        bulk_action_scope
        .where(bulk_action_id_param => params[bulk_action_id_param])
        .pluck(bulk_action_id_param)
    end

    def bulk_action_item_ids
      (Rails.cache.read(bulk_action_session_key) || []).to_set
    end

    def bulk_action_reset
      Rails.cache.write(bulk_action_session_key, [])
    end

    def bulk_action_append_item_ids(values)
      new_values = bulk_action_item_ids.merge(values)
      Rails.cache.write(bulk_action_session_key, new_values.to_a)
    end

    def bulk_action_remove_item_ids(values)
      new_values = bulk_action_item_ids.subtract(values)
      Rails.cache.write(bulk_action_session_key, new_values.to_a)
    end
  end
end
