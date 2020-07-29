module CampaignUsersHelper
  extend ActiveSupport::Concern

  ATTRIBUTES = [
    :class_params, :permitted_params, :show_attributes,
    :list_attributes, :resource_name, :images_attributes,
    :nesteds, :belongs, :show_block, :admin_options
  ]

  included do
    begin
      before_action :set_base_helper
    rescue Exception => e
    end
  end

  def set_base_helper
    @base_helper = CampaignUsersHelper
  end

  mattr_reader *ATTRIBUTES

  @@class_params = []

  @@permitted_params = [:id] + @@class_params
  @@show_attributes = [:id] + @@class_params
  @@images_attributes = []
  @@list_attributes = @@class_params
  @@resource_name = "campaign_user"
  @@belongs = {
    user: {
      attributes: [:id, :name, :avatar_timeline, :admin, :admin_current_domain]
    },
    campaign: {
      attributes: [:id, :title, :image_timeline, :redeem_points?]
    },
  }

  @@show_block = Proc.new {
    node :formatted_title_admin do |object|

      user_link = %{
        #{image_tag(object.user.avatar(:s50x50), class: "pull-left mr10 img-circle")}
        <span class="text-muted">#{I18n.l(object.created_at)}</span> <br />
        #{ActionController::Base.helpers.link_to(object.user.name, "/dashboard/usuarios/#{object.user.id}")}
      }.html_safe

      I18n.t "admin.redeem.title_html", user: user_link, campaign: ActionController::Base.helpers.link_to(object.campaign.title, "/dashboard/admin/campaigns/#{object.campaign.id}/edit")
    end

    node :user_name do |object|
      object.user.name
    end

    node :campaign_title do |object|
      object.campaign.title
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
          item_hash = {
            id: comment.id,
            content: comment.content,
            created_at: comment.created_at,
            linked_content: comment.linked_content,

          }

          if comment.user.present?
            item_hash[:user] = {
              id: comment.user.id,
              name: comment.user.name,
              avatar: comment.user.avatar,
              admin_current_domain: comment.user.admin_current_domain,
            }
          end
          item_hash
        end
      }
    end
  }

  @@admin_options = {
    title: 'views.dashboard.admin.campaign_users.index.title',
    slug: "campaign_users",
    slug_singular: "campaign_user",
    item_title_field: 'formatted_title_admin',
    ico_class: 'ico-bubble-up',
    remove_add_button_from_list: true,
    remove_edit_button_from_list: true,
    buttons: {
      index_add: 'views.dashboard.admin.campaign_users.buttons.add',
    },
    edit: {
      title_add: 'views.dashboard.admin.campaign_users.buttons.add',
      title_edit: 'views.dashboard.admin.campaign_users.edit.title',
    },
    errorMapping: {
    },
    form: {
      fields: [
        {
          name: :user_name,
          display_name: 'views.dashboard.admin.campaign_users.fields.user_name',
          input: :text,
          disabled: true,
        },
        {
          name: :campaign_title,
          display_name: 'views.dashboard.admin.campaign_users.fields.campaign_title',
          input: :text,
          disabled: true,
        },
      ],
    },
  }
end
