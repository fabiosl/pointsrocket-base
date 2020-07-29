module TrailsHelper
  extend ActiveSupport::Concern

  ATTRIBUTES = [:class_params, :permitted_params, :show_attributes,
    :list_attributes, :resource_name, :admin_options, :images_attributes, :nesteds]

  mattr_reader *ATTRIBUTES

  included do
    begin
      before_action :set_base_helper
    rescue Exception => e
    end
  end

  def set_base_helper
    @base_helper = TrailsHelper
  end

  @@class_params = [:name, :active, :description, :hours, :age_group, :video_url, :position]

  @@nesteds = {
    course_trails: {
      fields: {
        course_id: {}
      }
    },
    category_links: {
      fields: {
        category_id: {}
      }
    }
  }

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
  @@images_attributes = []
  @@list_attributes = @@class_params
  @@resource_name = "trail"

  @@admin_options = {
    title: "Trilhas",
    slug: "trails",
    slug_singular: "trail",
    item_title_field: 'name',
    ico_class: 'ico-flag2',
    buttons: {
      index_add: "Adicionar nova Trilha",
    },
    edit: {
      title_add: "Adicione uma nova Trilha",
      title_edit: "Edição da Trilha",
    },
    errorMapping: {
      :name => "Nome",
      :active => "Ativo",
      :description => "Descrição",
      :hours => "Horas",
      :age_group => "Faixa Etária",
      :video_url => "Url do vídeo",
      :position => "Posição",
    },
    form: {
      fields: [
        {
          name: :name,
          display_name: 'Nome',
          help: "Digite o nome do plano",
          input: :text,
          default: "",
          required: true,
        },
        {
          name: :active,
          display_name: 'Ativo',
          input: :checkbox,
          default: true,
        },
        {
          name: :description,
          display_name: 'Descrição',
          input: :textarea,
          required: true,
        },
        {
          name: :hours,
          display_name: 'Horas',
          input: :text,
          required: true,
        },
        {
          name: :age_group,
          display_name: 'Faixa Etária',
          input: :text,
          required: true,
        },
        {
          name: :video_url,
          display_name: 'Url do vídeo',
          input: :text,
        },
        {
          name: :position,
          display_name: 'Posição',
          input: :text,
          required: false,
          default: 0,
        },
        {
          name: :course_trails,
          display_name: 'Cursos',
          add_nested_button_name: "Adicione outro curso",
          type: :nested,
          fields: [
            {
              name: :course_id,
              display_name: "Curso",
              type: "reference",
              options: [],
              options_url: '/api/domains/{{domain_id}}/courses',
              option_display: :name,
              option_value: :id
            },

            {
              name: :_destroy,
              display_name: "Apagar",
              input: "checkbox",
              default: false,
            }
          ]
        },

        {
          name: :category_links,
          display_name: 'Categorias',
          add_nested_button_name: "Adicione outra categoria",
          type: :nested,
          fields: [
            {
              name: :category_id,
              display_name: "Categoria",
              type: "reference",
              options: [],
              options_url: '/api/domains/{{domain_id}}/categories',
              option_display: :name,
              option_value: :id
            },

            {
              name: :_destroy,
              display_name: "Apagar",
              input: "checkbox",
              default: false,
            }
          ]
        },
      ],
    },
  }
end
