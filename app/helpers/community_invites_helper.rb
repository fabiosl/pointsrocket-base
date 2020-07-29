module CommunityInvitesHelper
  extend ActiveSupport::Concern

  ATTRIBUTES = [
    :class_params, :permitted_params, :show_attributes,
    :list_attributes, :resource_name, :admin_options,
    :images_attributes, :belongs
  ]

  mattr_reader *ATTRIBUTES

  included do
    begin
      before_action :set_base_helper
    rescue Exception => e
    end
  end

  def set_base_helper
    @base_helper = CommunityInvitesHelper
  end

  @@class_params = [:status]

  @@permitted_params = [:id] + @@class_params
  @@show_attributes = [:id, :created_at] + @@class_params
  @@images_attributes = []
  @@list_attributes = @@class_params
  @@resource_name = 'community_invite'

  @@belongs = {
    user: {
      attributes: [:id, :name, :email, :avatar]
    }
  }
  @@admin_options = {
    title: 'views.dashboard.admin.community_invites.index.title',
    slug: "community_invites",
    slug_singular: "community_invite",
    item_title_field: 'inviteItemTitleField()',
    ico_class: 'ico-user-plus2',
    remove_add_button_from_list: true,
    remove_edit_button_from_list: true,
    buttons: {
      index_add: 'views.dashboard.admin.invites.buttons.add',
    },
    edit: {
      title_add: 'views.dashboard.admin.invites.buttons.add',
      title_edit: 'views.dashboard.admin.invites.edit.title',
    },
    errorMapping: {
      token: 'views.dashboard.admin.invites.fields.token',
      email: 'views.dashboard.admin.invites.fields.email',
      status: 'views.dashboard.admin.invites.fields.status',
    },
    form: {
      fields: [
        {
          name: :email,
          display_name: 'views.dashboard.admin.invites.fields.email',
          input: :text,
          readonly: true
        },
        {
          name: :token,
          display_name: 'views.dashboard.admin.invites.fields.token',
          input: :text,
          readonly: true
        },
        {
          name: :status,
          display_name: 'views.dashboard.admin.invites.fields.status',
          input: :text,
          readonly: true
        },
      ],
    },
  }
end
