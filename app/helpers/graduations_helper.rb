module GraduationsHelper
  extend ActiveSupport::Concern

  ATTRIBUTES = [:class_params, :permitted_params, :show_attributes,
    :list_attributes, :resource_name, :admin_options, :images_attributes,
    :belongs]

  mattr_reader *ATTRIBUTES

  included do
    begin
      before_action :set_base_helper
    rescue Exception => e
    end
  end

  def set_base_helper
    @base_helper = GraduationsHelper
  end

  @@class_params = [:user_id, :course_id]

  @@permitted_params = [:id] + @@class_params
  @@show_attributes = [:id] + @@class_params + [:user_id]
  @@images_attributes = []
  @@list_attributes = @@class_params
  @@resource_name = "graduation"
  @@belongs = {
    user: {
      attributes: [:id, :name, :admin, :avatar_timeline, :admin_current_domain, :avatar]
    },
    course: {
      attributes: [:id, :name, :avatar, :slug]
    },
  }
end
