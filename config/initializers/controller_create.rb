def controller_create
  class_eval do

    # POST /api/{plural_resource_name}
    def controller_action_create
      set_resource(resource_class.new(resource_params))

      resource = get_resource
      resource_saved = resource.save
      if block_given?
        yield resource
      else
        if resource_saved
          render :show, status: :created
        else
          render json: get_resource.errors, status: :unprocessable_entity
        end
      end

    end

  end
end
