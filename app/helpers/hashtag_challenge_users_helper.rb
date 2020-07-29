module HashtagChallengeUsersHelper
  extend ActiveSupport::Concern

  ATTRIBUTES = [
    :class_params, :permitted_params, :show_attributes,
    :list_attributes, :resource_name, :admin_options,
    :images_attributes, :belongs, :show_block
  ]

  mattr_reader *ATTRIBUTES

  included do
    begin
      before_action :set_base_helper
    rescue Exception => e
    end
  end

  def set_base_helper
    @base_helper = HashtagChallengeUsersHelper
  end

  @@class_params = [:status, :feedback, :notify]

  @@permitted_params = [:id] + @@class_params + [:notification_options => [:type]]
  @@show_attributes = [:id] + @@class_params + [
    :hashtag_challenge_id, :user_id, :url, :created_at, :json]
  @@images_attributes = []
  @@list_attributes = @@class_params
  @@resource_name = "hashtag_challenge_user"
  @@belongs = {
    user: {
      attributes: [:id, :name, :avatar, :avatar_timeline, :admin, :admin_current_domain]
    },
    hashtag_challenge: {
      attributes: [:id, :title, :image, :full_image, :slug]
    },
    points: {
      attributes: [:id, :value]
    },
  }

  @@show_block = Proc.new {
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
  }

  @@admin_options = {
    title: 'views.dashboard.admin.hashtag_challenges_users.index.title',
    slug: "hashtag_challenge_users",
    slug_singular: "hashtag_challenge_user",
    item_title_field: 'hashtag_challenge()',
    ico_class: 'ico-pencil',
    list_item_template: "hashtag_challenge_user_list_item",
    buttons: {
      index_add: 'views.dashboard.admin.hashtag_challenges_users.buttons.add',
    },
    edit: {
      title_add: 'views.dashboard.admin.hashtag_challenges_users.buttons.add',
      title_edit: 'views.dashboard.admin.hashtag_challenges_users.edit.title',
    },
    errorMapping: {
      hashtag_challenge_id: 'views.dashboard.admin.hashtag_challenges_users.fields.hashtag_challenge',
      user_id: 'views.dashboard.admin.hashtag_challenges_users.fields.user',
      url: 'views.dashboard.admin.hashtag_challenges_users.fields.url',
      status: 'views.dashboard.admin.hashtag_challenges_users.fields.status',
      feedback: 'views.dashboard.admin.hashtag_challenges_users.fields.feedback',
    },
    form: {
      params_to_send: {
        notify: true
      },
      fields: [
        {
          name: :hashtag_challenge_id,
          display_name: 'views.dashboard.admin.hashtag_challenges_users.fields.hashtag_challenge',
          type: "reference",
          options: [],
          options_url: '/api/hashtag_challenges',
          option_display: :title,
          option_value: :id,
          readonly: true
        },
        {
          name: :user_id,
          display_name: 'views.dashboard.admin.hashtag_challenges_users.fields.user',
          input: :text,
          readonly: true
        },
        {
          name: :url,
          display_name: 'views.dashboard.admin.hashtag_challenges_users.fields.url',
          input: :text,
          readonly: true
        },
        {
          name: :status,
          display_name: 'views.dashboard.admin.hashtag_challenges_users.fields.status',
          input: :select,
          options: [{

            value: "pending",
            label: 'views.dashboard.admin.hashtag_challenges_users.statuses.pending'
          },{

            value: "approved",
            label: 'views.dashboard.admin.hashtag_challenges_users.statuses.approved'
          },{

            value: "declined",
            label: 'views.dashboard.admin.hashtag_challenges_users.statuses.declined'
          }]
        },
        {
          name: :feedback,
          display_name: 'views.dashboard.admin.hashtag_challenges_users.fields.feedback',
          input: :textarea
        },
      ],
    },
  }
end
