module CompleteAccountQuestionsHelper
  extend ActiveSupport::Concern

  ATTRIBUTES = [:class_params, :permitted_params, :show_attributes,
    :list_attributes, :resource_name, :admin_options, :images_attributes,
    :show_block, :belongs, :nesteds]

  mattr_reader *ATTRIBUTES

  included do
    begin
      before_action :set_base_helper
    rescue Exception => e
    end
  end

  def set_base_helper
    @base_helper = CompleteAccountQuestionsHelper
  end

  @@class_params = [:title]
  @@nesteds = {
    complete_account_question_options: {
      fields: {
        name: {}
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
  @@resource_name = "complete_account_question"

  @@belongs = {
    complete_account_question_options: {
      attributes: [:id, :name]
    }
  }

  @@admin_options = {
    title: 'views.dashboard.admin.complete_account_questions.fields.title',
    slug: "complete_account_questions",
    slug_singular: "complete_account_question",
    item_title_field: 'title',
    ico_class: 'ico-question-sign',
    buttons: {
      index_add: 'views.dashboard.admin.complete_account_questions.buttons.add',
    },
    edit: {
      title_add: 'views.dashboard.admin.complete_account_questions.buttons.add',
      title_edit: 'views.dashboard.admin.complete_account_questions.edit.title',
    },
    errorMapping: {
      :title => 'views.dashboard.admin.complete_account_questions.fields.title',
    },
    form: {
      fields: [
        {
          name: :title,
          display_name: 'views.dashboard.admin.complete_account_questions.fields.title',
          input: :text,
          required: true,
        },
        {
          name: :complete_account_question_options,
          display_name: 'views.dashboard.admin.complete_account_question_options.edit.title',
          add_nested_button_name: "views.dashboard.admin.complete_account_question_options.buttons.add",
          type: :nested,
          fields: [
            {
              name: :name,
              display_name: "views.dashboard.admin.complete_account_question_options.fields.name",
              input: "text",
              required: true,
            },

            {
              name: :_destroy,
              display_name: "views.dashboard.admin.complete_account_question_options.buttons.delete",
              input: "checkbox",
              default: false,
            }
          ]
        },
      ],
    },
  }


end
