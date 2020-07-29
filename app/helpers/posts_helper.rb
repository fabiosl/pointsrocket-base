module PostsHelper
  extend ActiveSupport::Concern

  ATTRIBUTES = [
    :class_params, :permitted_params, :show_attributes,
    :list_attributes, :resource_name, :admin_options,
    :belongs, :images_attributes, :show_block
  ]

  mattr_reader *ATTRIBUTES

  included do
    begin
      before_action :set_base_helper
    rescue Exception => e
    end
  end

  def set_base_helper
    @base_helper = PostsHelper
  end

  @@class_params = [:content, :user]

  @@permitted_params = [:id] + @@class_params
  @@show_attributes = [:id, :viewer_ids, :linked_content] + @@class_params
  @@images_attributes = []
  @@list_attributes = @@class_params
  @@resource_name = "post"
  @@belongs = {
    user: {
      attributes: [:id, :name, :avatar, :avatar_timeline, :admin, :admin_current_domain]
    }
  }

  @@show_block = Proc.new {
    #TO-DO: Refactor these comments block to remove duplicity over other helpers
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
  #   title: 'views.dashboard.admin.challenges.index.title',
  #   slug: "challenges",
  #   slug_singular: "challenge",
  #   item_title_field: 'title',
  #   ico_class: 'ico-bubble-up',
  #   buttons: {
  #     index_add: 'views.dashboard.admin.challenges.buttons.add',
  #   },
  #   edit: {
  #     title_add: 'views.dashboard.admin.challenges.buttons.add',
  #     title_edit: 'views.dashboard.admin.challenges.edit.title',
  #   },
  #   errorMapping: {
  #     title: 'views.dashboard.admin.challenges.fields.title',
  #     description: 'views.dashboard.admin.challenges.fields.description',
  #     date_start: 'views.dashboard.admin.challenges.fields.date_start',
  #     date_end: 'views.dashboard.admin.challenges.fields.date_end',
  #     points: 'views.dashboard.admin.challenges.fields.points',
  #     image: 'views.dashboard.admin.challenges.fields.image',
  #     slug: 'views.dashboard.admin.challenges.fields.slug',
  #     badge_id: 'views.general.medal',
  #     terms: 'views.dashboard.admin.challenges.fields.terms',
  #   },
  #   others_links: [
  #     {
  #       name: "Submissões",
  #       url: '/dashboard/admin/challenge_users'
  #     }
  #   ],
  #   form: {
  #     fields: [
  #       {
  #         name: :title,
  #         display_name: 'views.dashboard.admin.challenges.fields.title',
  #         input: :text,
  #         required: true,
  #       },
  #       {
  #         name: :description,
  #         display_name: 'views.dashboard.admin.challenges.fields.description',
  #         input: :textarea,
  #         summernote: true
  #       },
  #       {
  #         name: :date_start,
  #         display_name: 'views.dashboard.admin.challenges.fields.date_start',
  #         input: :datetime,
  #       },
  #       {
  #         name: :date_end,
  #         display_name: 'views.dashboard.admin.challenges.fields.date_end',
  #         input: :datetime,
  #       },
  #       {
  #         name: :points,
  #         display_name: 'views.dashboard.admin.challenges.fields.points',
  #         input: :text,
  #         required: true,
  #       },
  #       {
  #         name: :image,
  #         display_name: 'views.dashboard.admin.challenges.fields.image',
  #         input: :image,
  #         required: true,
  #         help: "Png/jpg 630x315 pixels"
  #       },
  #       {
  #         name: :badge_id,
  #         display_name: 'views.general.medal',
  #         type: "reference",
  #         options: [],
  #         options_url: '/api/badges',
  #         option_display: :name,
  #         option_value: :id
  #       },
  #       {
  #         name: :terms,
  #         display_name: 'views.dashboard.admin.challenges.fields.terms',
  #         input: :textarea,
  #         summernote: true
  #       },
  #     ],
  #   },
  }
end
