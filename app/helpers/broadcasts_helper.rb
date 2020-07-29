module BroadcastsHelper
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
    @base_helper = BroadcastsHelper
  end

  @@class_params = [:title, :url, :description, :points, :schedule_time, :badge_id]

  @@permitted_params = [:id] + @@class_params
  @@show_attributes = [:id] + @@class_params
  @@images_attributes = []
  @@list_attributes = @@class_params
  @@resource_name = 'broadcast'

  @@admin_options = {
    title: 'views.dashboard.admin.broadcasts.index.title',
    slug: 'broadcasts',
    slug_singular: 'broadcast',
    item_title_field: 'title',
    ico_class: 'ico-camera6',
    buttons: {
      index_add: 'views.dashboard.admin.broadcasts.buttons.add',
    },
    edit: {
      title_add: 'views.dashboard.admin.broadcasts.buttons.add',
      title_edit: 'views.dashboard.admin.broadcasts.edit.title',
    },
    errorMapping: {
      title: 'views.dashboard.admin.broadcasts.fields.title',
      url: 'views.dashboard.admin.broadcasts.fields.url',
      start_datetime: 'views.dashboard.admin.broadcasts.fields.start_datetime'
    },
    form: {
      fields: [
        {
          name: :title,
          display_name: 'views.dashboard.admin.broadcasts.fields.title',
          input: :text,
          required: true
        },
        {
          name: :url,
          display_name: 'views.dashboard.admin.broadcasts.fields.url',
          help: 'views.dashboard.admin.broadcasts.helpers.embed_url',
          help_text: 'views.dashboard.admin.broadcasts.helpers.create_youtube_broadcast',
          input: :text,
          required: true
        },
        {
          name: :description,
          display_name: 'views.dashboard.admin.broadcasts.fields.description',
          input: :textarea,
          required: true,
          summernote: true
        },
        {
          name: :points,
          display_name: 'views.dashboard.admin.broadcasts.fields.points',
          input: :text,
          required: true
        },
        {
          name: :schedule_time,
          display_name: 'views.dashboard.admin.broadcasts.fields.start_datetime',
          input: :datetime,
          datetime_type: 'start'
        },
        {
          name: :badge_id,
          display_name: 'views.general.medal',
          type: "reference",
          options: [],
          options_url: '/api/badges',
          option_display: :name,
          option_value: :id
        }
      ]
    }
  }
end
