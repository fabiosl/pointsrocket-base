module PointsHelper
  extend ActiveSupport::Concern

  ATTRIBUTES = [:show_attributes, :images_attributes, :belongs]

  mattr_reader *ATTRIBUTES

  included do
    begin
      before_action :set_base_helper
    rescue Exception => e
    end
  end

  def set_base_helper
    @base_helper = PointsHelper
  end

  @@class_params = [:user_id, :pointable_id, :pointable_type, :value]

  @@show_attributes = [:id] + @@class_params + [
    :challenge_id, :user_id, :url, :description, :created_at]
  @@images_attributes = []
  @@list_attributes = @@class_params
  @@belongs = {
    user: {
      attributes: [:id, :name, :avatar, :admin]
    }
  }
end
