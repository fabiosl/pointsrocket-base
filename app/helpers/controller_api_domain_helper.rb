module ControllerApiDomainHelper
  extend ActiveSupport::Concern

  included do
    begin
      before_filter :authenticate_user!
      skip_before_action :verify_authenticity_token

      class_eval %Q{
        def #{self.controller_name.singularize}_params
          the_params = params.require(:#{self.controller_name.singularize}).permit(@@permitted_params)
          the_params
        end
      }
    rescue Exception => e
    end
  end

  def index
    plural_resource_name = "@#{resource_name.pluralize}"
    resources = resource_class.all.order(id: :desc)
    # resources = resources.order(id: :desc)
    instance_variable_set(plural_resource_name, resources)
  end

  def create
    super
    if get_resource.respond_to? :tag_list
      get_resource.tag_list = @domain.tag_list
    end
    get_resource.save
  end
end
