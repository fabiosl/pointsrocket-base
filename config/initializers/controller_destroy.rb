def controller_destroy
  class_eval do

    before_action :set_resource, only: [:destroy]

    # POST /api/{plural_resource_name}
    def controller_action_destroy(to_render = true)
      get_resource.destroy
      if to_render
        head :no_content
      end
    end

  end
end
