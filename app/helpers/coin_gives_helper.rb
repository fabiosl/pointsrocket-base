module CoinGivesHelper
  extend ActiveSupport::Concern

  ATTRIBUTES = [:class_params, :permitted_params, :show_attributes,
    :list_attributes, :resource_name, :images_attributes,
    :belongs, :show_block]

  mattr_reader *ATTRIBUTES

  included do
    begin
      before_action :set_base_helper
    rescue Exception => e
    end
  end

  def set_base_helper
    @base_helper = CoinGivesHelper
  end

  @@class_params = [:content]

  @@permitted_params = [:id] + @@class_params
  @@show_attributes = [:id] + @@class_params
  @@images_attributes = []
  @@list_attributes = @@class_params
  @@resource_name = "coin_give"
  @@belongs = {
    user: {
      attributes: [:id, :name, :avatar, :avatar_timeline, :admin, :admin_current_domain]
    }
  }

  @@show_block = Proc.new {

    node :formatted_content do |obj|
      obj.decorate.formatted_content
    end

    node :formatted_action do |obj|
      obj.decorate.formatted_action
    end

    child :coin_users do
      attributes :id

      child recipient: :recipient do
        attributes :id, :name, :avatar, :avatar_timeline, :admin, :admin_current_domain
      end

      child sender: :sender do
        attributes :id, :name, :avatar, :avatar_timeline, :admin, :admin_current_domain
      end
    end

    node :comments do |object|
      comments_paginated = object.comments.order(created_at: :desc).page(1)
      {
        count: object.comments.size,
        current_page: comments_paginated.current_page,
        per_page: comments_paginated.per_page,
        total_pages: comments_paginated.total_pages,
        has_next_page: !!comments_paginated.next_page,
        items: comments_paginated.sort_by(&:created_at).map do |comment|
          {
            id: comment.id,
            content: comment.content,
            created_at: comment.created_at,
            linked_content: comment.linked_content,
            user: {
              id: comment.user.id,
              name: comment.user.name,
              avatar: comment.user.avatar,
              admin_current_domain: comment.user.admin_current_domain
            }
          }
        end
      }
    end
  }

end
