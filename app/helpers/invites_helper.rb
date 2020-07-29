module InvitesHelper
  extend ActiveSupport::Concern

  ATTRIBUTES = [:class_params, :permitted_params, :show_attributes,
    :list_attributes, :resource_name, :admin_options, :images_attributes]

  mattr_reader *ATTRIBUTES

  included do
    begin
      before_action :set_base_helper
    rescue Exception => e
    end
  end

  def set_base_helper
    @base_helper = InvitesHelper
  end

  @@class_params = [:status, :email]

  @@permitted_params = [:id] + @@class_params
  @@show_attributes = [:id] + @@class_params + [:token]
  @@images_attributes = []
  @@list_attributes = @@class_params
  @@resource_name = "invite"
  @@admin_options = {
    title: 'views.dashboard.admin.invites.index.title',
    slug: "invites",
    slug_singular: "invite",
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
    top_actions: [
      {
        name: "Convidar",
        action: 'openInviteModal()'
      }
    ],
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
