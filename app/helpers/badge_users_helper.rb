module BadgeUsersHelper
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
    @base_helper = BadgeUsersHelper
  end

  #  user_id    :integer
  #  badge_id   :integer
  #  created_at :datetime
  #  updated_at :datetime
  #  quantity   :integer          default(1)

  @@class_params = [:badge_id, :quantity]

  @@permitted_params = [:id] + @@class_params
  @@show_attributes = [:id] + @@class_params + [
    :user_id]
  @@images_attributes = []
  @@list_attributes = @@class_params
  @@resource_name = "badge_user"
  @@belongs = {
    user: {
      attributes: [:id, :name, :admin, :admin_current_domain, :avatar, :avatar_timeline]
    },
    badge: {
      attributes: [:id, :name, :avatar]
    },
  }

  @@admin_options = {
    title: "Submissões dos Desafios",
    slug: "badge_users",
    slug_singular: "badge_user",
    item_title_field: 'challenge()',
    ico_class: 'ico-pencil',
    buttons: {
      index_add: "Adicionar nova Submissão de Desafio",
    },
    edit: {
      title_add: "Adicione uma nova Submissão de Desafio",
      title_edit: "Edição da Submissão",
    },
    errorMapping: {
      challenge_id: "Desafio",
      user_id: "Usuário",
      url: "Link da rede social",
      description: "Descrição",
      status: "Status",
      feedback: "feedback",
    },
    form: {
      params_to_send: {
        notify: true
      },
      fields: [
        {
          name: :challenge_id,
          display_name: "Desafio",
          type: "reference",
          options: [],
          options_url: '/api/challenges',
          option_display: :title,
          option_value: :id,
          readonly: true
        },
        {
          name: :user_id,
          display_name: "Usuário",
          input: :text,
          readonly: true
        },
        {
          name: :url,
          display_name: 'Url',
          input: :text,
          readonly: true
        },
        {
          name: :description,
          display_name: 'Descrição',
          input: :textarea,
          readonly: true
        },
        {
          name: :status,
          display_name: 'Status',
          input: :select,
          options: [{

            value: "pending",
            label: "Pendente"
          },{

            value: "approved",
            label: "Aprovado"
          },{

            value: "declined",
            label: "Não aprovado"
          }]
        },
        {
          name: :feedback,
          display_name: 'feedback',
          input: :textarea
        },
      ],
    },
  }
end
