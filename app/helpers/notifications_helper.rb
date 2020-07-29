module NotificationsHelper
  extend ActiveSupport::Concern

  ATTRIBUTES = [
    :class_params, :permitted_params, :show_attributes,
    :list_attributes, :resource_name, :admin_options,
    :images_attributes
  ]

  mattr_reader *ATTRIBUTES

  included do
    begin
      before_action :set_base_helper
    rescue Exception => e
    end
  end

  def set_base_helper
    @base_helper = NotificationsHelper
  end

  @@class_params = [:actor_id, :recipient_id, :notification_type,
    :notificable_id, :notificable_type]
  @@permitted_params = [:id] + @@class_params
  @@show_attributes = [:id] + @@class_params
  @@images_attributes = []
  @@list_attributes = @@class_params
  @@resource_name = "notification"

  @@admin_options = {
    title: "Notificações",
    slug: "notifications",
    slug_singular: "notification",
    item_title_field: 'name',
    ico_class: 'ico-flag2',
    buttons: {
      index_add: "Adicionar nova Notificação",
    },
    edit: {
      title_add: "Adicione um nova Notificação",
      title_edit: "Edição da Notificação",
    },
    errorMapping: {
      :creator_id => "Criador (Remetente)",
      :user_id => "Usuário (destinatário)",
      :notification_type => "Tipo",
      :notificable_id => "Notificável (ID)",
      :notificable_type => "Notificável (Type)",
      :title => "Título",
      :content => "Conteúdo",
    },
    form: {
      fields: [
        {
          name: :title,
          display_name: 'Título',
          input: :text,
          required: true,
        },
        {
          name: :content,
          display_name: 'Conteúdo',
          input: :text,
          required: true,
        },
      ],
    },
  }
end
