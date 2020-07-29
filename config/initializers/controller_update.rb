def controller_update
  class_eval do

    before_action :set_resource, only: [:update]

    # PATCH/PUT /api/{plural_resource_name}/1
    def controller_action_update
      updated = get_resource.update(resource_params)

      yield get_resource if block_given?

      # if not skip_render
      #   if updated
      #     render :show
      #   else
      #     render json: get_resource.errors, status: :unprocessable_entity
      #   end
      # end

    end

  end
end
