module CategoriesHelper
  extend ActiveSupport::Concern

  ATTRIBUTES = [:class_params, :permitted_params, :show_attributes,
    :list_attributes, :resource_name, :admin_options, :images_attributes,
  :nesteds]

  included do
    begin
      before_action :set_base_helper
    rescue Exception => e
    end
  end

  def set_base_helper
    @base_helper = CategoriesHelper
  end

  mattr_reader *ATTRIBUTES

  @@class_params = [:name, :slug, :position, :logo, :change_to_franchisee]

  @@nesteds = {}

  @@nesteds_permiteds = @@nesteds.keys.reduce({}) do |memo, key|
    memo[:"#{key}_attributes"] = @@nesteds[key][:fields].keys.map do |field_key|
      # coloquei dessa forma caso precise de algum processamento
      field_key
    end
    memo[:"#{key}_attributes"] += [:id, :_destroy]
    memo
  end

  @@permitted_params = [:id] + @@class_params + [@@nesteds_permiteds]
  @@show_attributes = [:id] + @@class_params
  @@images_attributes = [:logo]
  @@list_attributes = @@class_params
  @@resource_name = "category"

  @@admin_options = {
    title: "Categorias",
    slug: "categories",
    slug_singular: "category",
    item_title_field: 'name',
    ico_class: 'ico-flag2',
    buttons: {
      index_add: "Adicionar nova Categoria",
    },
    edit: {
      title_add: "Adicione uma nova Categoria",
      title_edit: "Edição da Categoria",
    },
    errorMapping: {
      :name => "Nome",
      :slug => "Slug",
      :position => "Posição (Ordem)",
    },
    form: {
      fields: [
        {
          name: :name,
          display_name: 'Nome',
          help: "Digite o nome",
          input: :text,
          default: "",
          required: true,
        },
        {
          name: :slug,
          display_name: 'Slug',
          input: :text,
          default: "",
        },
        {
          name: :change_to_franchisee,
          display_name: 'Alterar logo para os franqueados',
          input: :checkbox,
          default: false,
        },
        {
          name: :logo,
          display_name: 'Logo',
          input: :image,
        },
      ],
    },
  }
end
