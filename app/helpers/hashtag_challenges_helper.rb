module HashtagChallengesHelper
  extend ActiveSupport::Concern

  ATTRIBUTES = [:class_params, :permitted_params, :show_attributes,
    :list_attributes, :resource_name, :admin_options, :images_attributes,
    :belongs, :show_block]

  mattr_reader *ATTRIBUTES

  included do
    begin
      before_action :set_base_helper
    rescue Exception => e
    end
  end

  def set_base_helper
    @base_helper = HashtagChallengesHelper
  end

  @@class_params = [:title, :description, :date_start, :date_end, :points,
    :image, :slug, :badge_id, :terms, :hashtag,
    :social_interactions_multiplier]

  @@permitted_params = [:id] + @@class_params
  @@show_attributes = [:id] + @@class_params + [:formatted_date_start, :formatted_date_end, :full_image, :timeline_image]
  @@images_attributes = [:image]
  @@list_attributes = @@class_params
  @@resource_name = "hashtag_challenge"
  @@belongs = {
    badge: {
      attributes: [:id, :name, :avatar_timeline]
    }
  }

  @@show_block = Proc.new {
    if respond_to? :current_user
      node :approved do |obj|
        current_user.hashtag_challenge_approved? obj
      end
    end

    node :hashtag_challenge_users_info do |obj|
      participating_people = User.where(id: obj.hashtag_challenge_users.visible.group("user_id").pluck("user_id")).limit(2)
      participating_people_count = obj.hashtag_challenge_users.visible.group("user_id").count.size

      participating_key = obj.has_passed? ? "views.hashtag_challenges.index.have_published_past" : "views.hashtag_challenges.index.have_published"

      {
        count: participating_people_count,
        participating_title: I18n.t(participating_key, count: participating_people_count),
        users: participating_people.map do |user|
          {
            name: user.name,
            avatar: user.avatar.url(:s50x50),
          }
        end
      }
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
  }

  @@admin_options = {
    title: 'views.dashboard.admin.hashtag_challenges.index.title',
    slug: "hashtag_challenges",
    slug_singular: "hashtag_challenge",
    item_title_field: 'title',
    ico_class: 'ico-bubble-up',
    buttons: {
      index_add: 'views.dashboard.admin.hashtag_challenges.buttons.add',
    },
    edit: {
      title_add: 'views.dashboard.admin.hashtag_challenges.buttons.add',
      title_edit: 'views.dashboard.admin.hashtag_challenges.edit.title',
    },
    errorMapping: {
      title: 'views.dashboard.admin.hashtag_challenges.fields.title',
      description: 'views.dashboard.admin.hashtag_challenges.fields.description',
      date_start: 'views.dashboard.admin.hashtag_challenges.fields.date_start',
      date_end: 'views.dashboard.admin.hashtag_challenges.fields.date_end',
      points: 'views.dashboard.admin.hashtag_challenges.fields.points',
      image: 'views.dashboard.admin.hashtag_challenges.fields.image',
      slug: 'views.dashboard.admin.hashtag_challenges.fields.slug',
      badge_id: 'views.general.medal',
      terms: 'views.dashboard.admin.hashtag_challenges.fields.terms',
      hashtag: 'views.dashboard.admin.hashtag_challenges.fields.hashtag',
    },
    others_links: [
      {
        name: "Publicações",
        url: '/dashboard/admin/hashtag_challenge_users'
      }
    ],
    form: {
      fields: [
        {
          name: :title,
          display_name: 'views.dashboard.admin.hashtag_challenges.fields.title',
          input: :text,
          required: true,
        },
        {
          name: :hashtag,
          display_name: 'views.dashboard.admin.hashtag_challenges.fields.hashtag',
          input: :text,
          help: "#hashtag",
        },
        {
          name: :social_interactions_multiplier,
          display_name: 'views.dashboard.admin.hashtag_challenges.fields.social_interactions_multiplier',
          input: :text,
          help: "if you want to a user gain 2 points by each interaction, put 2. If you want to a user gain 1 point each 10 publication, put 0.1. And so on"
        },
        {
          name: :description,
          display_name: 'views.dashboard.admin.hashtag_challenges.fields.description',
          input: :textarea,
          summernote: true
        },
        {
          name: :date_start,
          display_name: 'views.dashboard.admin.hashtag_challenges.fields.date_start',
          input: :datetime,
          datetime_type: 'start'
        },
        {
          name: :date_end,
          display_name: 'views.dashboard.admin.hashtag_challenges.fields.date_end',
          input: :datetime,
          datetime_type: 'end'
        },
        {
          name: :points,
          display_name: 'views.dashboard.admin.hashtag_challenges.fields.points',
          input: :text,
          required: true,
        },
        {
          name: :image,
          display_name: 'views.dashboard.admin.hashtag_challenges.fields.image',
          input: :image,
          required: true,
          help: "GIF/JPG/PNG. GIF max.: 1Mb"
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
      ],
    },
  }
end
