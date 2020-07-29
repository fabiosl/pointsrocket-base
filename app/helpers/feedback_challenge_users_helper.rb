module FeedbackChallengeUsersHelper
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
    @base_helper = ChallengeUsersHelper
  end

  @@class_params = [:status, :feedback, :notify, :challenge_id]

  @@permitted_params = [:id] + @@class_params + [:notification_options => [:type]]
  @@show_attributes = [:id] + @@class_params + [
    :challenge_id, :user_id, :url, :description, :created_at, :approved?,
    :declined?, :pending?, :json
  ]
  @@images_attributes = []
  @@list_attributes = @@class_params
  @@resource_name = "challenge_user"
  @@belongs = {
    user: {
      attributes: [:id, :name, :avatar, :avatar_timeline, :admin]
    },
    challenge: {
      attributes: [:id, :title, :image, :full_image, :slug]
    },
    points: {
      attributes: [:id, :value]
    },
  }

  @@show_block = Proc.new do
    node :content do |object|
      if object.description.present?
        object.description.html_safe
      else
        "<a href='#{object.file.url}' target='_blank'>
          #{I18n.t('views.challenges.show.form.fields.file.title')}</a>
        "
      end
    end

    node :comments do |object|
      comments_paginated = object.comments.order(created_at: :desc).page(1)
      {
        count: object.comments.size,
        current_page: comments_paginated.current_page,
        per_page: comments_paginated.per_page,
        total_pages: comments_paginated.total_pages,
        has_next_page: !!comments_paginated.next_page,
        items: comments_paginated.sort_by(&:created_at).map do |comment|
          {
            id: comment.id,
            content: comment.content,
            created_at: comment.created_at,
            linked_content: comment.linked_content,
            user: {
              id: comment.user.id,
              name: comment.user.name,
              avatar: comment.user.avatar,
              admin_current_domain: comment.user.admin_current_domain
            }
          }
        end
      }
    end
  end

  @@admin_options = {
    title: 'views.dashboard.admin.feedbacks_users.index.title',
    slug: "challenge_users",
    slug_singular: "challenge_user",
    item_title_field: 'challenge()',
    ico_class: 'ico-pencil',
    list_item_template: "challenge_user_list_item",
    buttons: {
      index_add: 'views.dashboard.admin.feedbacks_users.buttons.add',
    },
    edit: {
      title_add: 'views.dashboard.admin.feedbacks_users.buttons.add',
      title_edit: 'views.dashboard.admin.feedbacks_users.edit.title',
    },
    errorMapping: {
      challenge_id: 'views.dashboard.admin.feedbacks_users.fields.challenge',
      user_id: 'views.dashboard.admin.feedbacks_users.fields.user',
      url: 'views.dashboard.admin.feedbacks_users.fields.url',
      description: 'views.dashboard.admin.feedbacks_users.fields.description',
      status: 'views.dashboard.admin.feedbacks_users.fields.status',
      feedback: 'views.dashboard.admin.feedbacks_users.fields.feedback',
    },
    form: {
      params_to_send: {
        notify: true
      },
      fields: [
        {
          name: :challenge_id,
          display_name: 'views.dashboard.admin.feedbacks_users.fields.challenge',
          type: "reference",
          options: [],
          options_url: '/api/challenges',
          option_display: :title,
          option_value: :id,
          readonly: true
        },
        {
          name: :user_id,
          display_name: 'views.dashboard.admin.feedbacks_users.fields.user',
          input: :text,
          readonly: true
        },
        {
          name: :url,
          display_name: 'views.dashboard.admin.feedbacks_users.fields.url',
          input: :text,
          readonly: true
        },
        {
          name: :description,
          display_name: 'views.dashboard.admin.feedbacks_users.fields.description',
          input: :textarea,
          readonly: true
        },
        {
          name: :status,
          display_name: 'views.dashboard.admin.feedbacks_users.fields.status',
          input: :select,
          options: [{

            value: "pending",
            label: 'views.dashboard.admin.feedbacks_users.statuses.pending'
          },{

            value: "approved",
            label: 'views.dashboard.admin.feedbacks_users.statuses.approved'
          },{

            value: "declined",
            label: 'views.dashboard.admin.feedbacks_users.statuses.declined'
          }]
        },
        {
          name: :feedback,
          display_name: 'views.dashboard.admin.feedbacks_users.fields.feedback',
          input: :textarea
        },
      ],
    },
  }
end
