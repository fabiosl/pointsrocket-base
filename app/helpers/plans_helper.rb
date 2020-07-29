module PlansHelper
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
    @base_helper = PlansHelper
  end

  @@class_params = [:name, :active, :duration, :price, :created_on_moip, :moip_code,
    :amount, :setup_fee, :interval_unit, :status, :description, :billing_cycles,
    :trial_days, :trial_hold_setup_fee]
  @@permitted_params = [:id] + @@class_params
  @@show_attributes = [:id] + @@class_params
  @@images_attributes = []
  @@list_attributes = @@class_params
  @@resource_name = "plan"

  @@admin_options = {
    title: "Planos",
    slug: "plans",
    slug_singular: "plan",
    item_title_field: 'name',
    ico_class: 'ico-flag2',
    buttons: {
      index_add: "Adicionar novo Plano",
    },
    edit: {
      title_add: "Adicione um novo Plano",
      title_edit: "Edição do Plano",
    },
    errorMapping: {
      :name => "Nome",
      :active => "Ativo",
      :duration => "Duração",
      :price => "Preço",
      :created_on_moip => "Criado no moip",
      :moip_code => "Código do moip",
      :amount => "Amount",
      :setup_fee => "Taxa de setup",
      :interval_unit => "Interval Unit",
      :status => "Status",
      :description => "descrição",
      :billing_cycles => "Ciclos de cobranças",
      :trial_days => "Dias trials",
      :trial_hold_setup_fee => "Trial hold setup fee",
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
          name: :duration,
          display_name: 'Duração',
          input: :text,
          required: true,
        },
        {
          name: :price,
          display_name: 'Preço',
          input: :text,
          required: true,
        },
        {
          name: :created_on_moip,
          display_name: 'Criado no Moip',
          input: :checkbox,
          default: false,
        },
        {
          name: :moip_code,
          display_name: 'Código no moip',
          input: :text,
        },
        {
          name: :amount,
          display_name: 'Amount (Preço)',
          input: :text,
        },
        {
          name: :setup_fee,
          display_name: 'Taxa de setup',
          input: :text
        },
        {
          name: :interval_unit,
          display_name: 'Interval Unit',
          input: :text,
        },
        {
          name: :status,
          display_name: 'Status',
          input: :text,
        },
        {
          name: :description,
          display_name: 'Descrição',
          input: :textarea,
        },
        {
          name: :billing_cycles,
          display_name: 'Ciclos de cobranças',
          input: :text,
        },
        {
          name: :trial_days,
          display_name: 'Dias trials',
          input: :text,
        },
        {
          name: :trial_hold_setup_fee,
          display_name: "Trial hold setup fee",
          input: :text,
        },
      ],
    },
  }
end
