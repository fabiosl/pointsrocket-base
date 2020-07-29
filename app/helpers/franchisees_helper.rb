module FranchiseesHelper
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
    @base_helper = FranchiseesHelper
  end

  @@class_params = [:name, :token, :logo]
  @@permitted_params = [:id] + @@class_params
  @@show_attributes = [:id] + @@class_params
  @@images_attributes = [:logo]
  @@list_attributes = @@class_params
  @@resource_name = "franchisee"

  @@admin_options = {
    title: "Franqueados",
    slug: "franchisees",
    slug_singular: "franchisee",
    item_title_field: 'name',
    ico_class: 'ico-flag2',
    buttons: {
      index_add: "Adicionar novo Franqueado",
    },
    edit: {
      title_add: "Adicione um novo Franqueado",
      title_edit: "Edição do Franqueado",
    },
    errorMapping: {
      name: "Nome",
      token: "Token",
      logo: "Logo",
    },
    form: {
      fields: [
        {
          name: :name,
          display_name: 'Nome',
          help: "Digite o nome do franqueado",
          input: :text,
          default: "",
          required: true,
        },
        {
          name: :token,
          display_name: 'Token',
          help: "Digite um token do franqueado e passe para o mesmo.",
          input: :text,
          default: "",
          required: true,
        },
        {
          name: :logo,
          display_name: 'Logo',
          help: "Imagem no formato x/y",
          default: "",
          input: :image,
        },
      ],
    },
  }

end
