module ChallengesHelper
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
    @base_helper = ChallengesHelper
  end

  @@class_params = [:title, :privacy, :description, :recommendation, :date_start, :date_end, :points,
    :image, :slug, :badge_id, :terms]

  @@permitted_params = [:id] + @@class_params
  @@show_attributes = [:id] + @@class_params + [:formatted_date_start, :formatted_date_end, :full_image, :timeline_image]
  @@images_attributes = [:image]
  @@list_attributes = @@class_params
  @@resource_name = "challenge"
  @@belongs = {
    badge: {
      attributes: [:id, :name, :avatar_timeline]
    }
  }

  @@show_block = Proc.new {

    if respond_to? :current_user
      node :approved do |obj|
        current_user.challenge_approved? obj
      end
    end

    node :challenge_users_info do |obj|
      participating_people = User.where(id: obj.challenge_users.visible.group("user_id").pluck("user_id")).limit(2)
      participating_people_count = obj.challenge_users.visible.group("user_id").count.size

      participating_key = obj.has_passed? ? "views.challenges.index.have_joined_past" : "views.challenges.index.have_joined"

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
      comments_paginated = object.comments.order(created_at: :asc).page(1)
      {
        count: object.comments.size,
        current_page: comments_paginated.current_page,
        per_page: comments_paginated.per_page,
        total_pages: comments_paginated.total_pages,
        has_next_page: !!comments_paginated.next_page,
        items: comments_paginated.map do |comment|
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
    title: 'views.dashboard.admin.challenges.index.title',
    slug: "challenges",
    slug_singular: "challenge",
    item_title_field: 'title',
    ico_class: 'ico-bubble-up',
    buttons: {
      index_add: 'views.dashboard.admin.challenges.buttons.add',
    },
    edit: {
      title_add: 'views.dashboard.admin.challenges.buttons.add',
      title_edit: 'views.dashboard.admin.challenges.edit.title',
    },
    errorMapping: {
      title: 'views.dashboard.admin.challenges.fields.title',
      description: 'views.dashboard.admin.challenges.fields.description',
      recommendation: 'views.dashboard.admin.challenges.fields.recommendation',
      date_start: 'views.dashboard.admin.challenges.fields.date_start',
      date_end: 'views.dashboard.admin.challenges.fields.date_end',
      points: 'views.dashboard.admin.challenges.fields.points',
      image: 'views.dashboard.admin.challenges.fields.image',
      slug: 'views.dashboard.admin.challenges.fields.slug',
      badge_id: 'views.general.medal',
      terms: 'views.dashboard.admin.challenges.fields.terms',
      hashtag: 'views.dashboard.admin.challenges.fields.hashtag',
    },
    others_links: [
      {
        name: "Submissões",
        url: '/dashboard/admin/challenge_users'
      }
    ],
    form: {
      fields: [
        {
          name: :title,
          display_name: 'views.dashboard.admin.challenges.fields.title',
          input: :text,
          required: true,
        },
        {
          name: :privacy,
          display_name: 'views.dashboard.admin.challenges.fields.privacy',
          input: :select,
          options: [
            {
              value: "all",
              label: 'views.dashboard.admin.challenges.privacy_statuses.all'
            },
            {
              value: "admin",
              label: 'views.dashboard.admin.challenges.privacy_statuses.admin'
            }
          ]
        },
        {
          name: :description,
          display_name: 'views.dashboard.admin.challenges.fields.description',
          input: :textarea,
          summernote: true
        },
        {
          name: :recommendation,
          display_name: 'views.dashboard.admin.challenges.fields.recommendation',
          input: :textarea,
          summernote: true
        },
        {
          name: :date_start,
          display_name: 'views.dashboard.admin.challenges.fields.date_start',
          input: :datetime,
          datetime_type: 'start'
        },
        {
          name: :date_end,
          display_name: 'views.dashboard.admin.challenges.fields.date_end',
          input: :datetime,
          datetime_type: 'end'
        },
        {
          name: :points,
          display_name: 'views.dashboard.admin.challenges.fields.points',
          input: :text,
          required: true,
        },
        {
          name: :image,
          display_name: 'views.dashboard.admin.challenges.fields.image',
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
        },
        {
          name: :terms,
          display_name: 'views.dashboard.admin.challenges.fields.terms',
          input: :textarea,
          summernote: true
        },
      ],
    },
  }
end
