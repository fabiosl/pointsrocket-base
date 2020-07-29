module CoinUsersHelper
  extend ActiveSupport::Concern

  ATTRIBUTES = [
    :class_params, :permitted_params, :show_attributes,
    :list_attributes, :resource_name, :images_attributes, :show_block
  ]

  mattr_reader *ATTRIBUTES

  included do
    begin
      before_action :set_base_helper
    rescue Exception => e
    end
  end

  def set_base_helper
    @base_helper = CoinUsersHelper
  end

  @@class_params = [:points]

  @@permitted_params = [:id] + @@class_params
  @@show_attributes = [:id] + @@class_params
  @@images_attributes = []
  @@list_attributes = @@class_params
  @@resource_name = "coin_user"

  @@show_block = Proc.new {
    node :action do |object|
      I18n.t('views.notifications.gave_points', points: object.points)
    end

    node :sender_action do |object|
      object.coin_give.decorate.formatted_action
    end

    node :coin_give do |object|
      coin_give = object.coin_give.decorate
      {
        id: coin_give.id,
        content: coin_give.formatted_content
      }
    end

    child recipient: :recipient do
      attributes :id, :name, :avatar, :avatar_timeline, :admin, :admin_current_domain
    end

    child sender: :sender do |object|
      attributes :id, :name, :avatar, :avatar_timeline, :admin, :admin_current_domain
    end

  }

end
