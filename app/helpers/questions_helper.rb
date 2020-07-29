module QuestionsHelper
  extend ActiveSupport::Concern

  ATTRIBUTES = [:class_params, :permitted_params, :show_attributes,
    :list_attributes, :resource_name, :images_attributes,
  :nesteds, :belongs, :show_block]

  included do
    begin
      before_action :set_base_helper
    rescue Exception => e
    end
  end

  #  id         :integer          not null, primary key
  #  title      :string(255)
  #  content    :text
  #  user_id    :integer
  #  step_id    :integer
  #  created_at :datetime
  #  updated_at :datetime

  def set_base_helper
    @base_helper = QuestionsHelper
  end

  mattr_reader *ATTRIBUTES

  @@class_params = [:title, :content, :linked_content]

  @@permitted_params = [:id] + @@class_params
  @@show_attributes = [:id] + @@class_params
  @@images_attributes = []
  @@list_attributes = @@class_params
  @@resource_name = "questions"
  @@belongs = {
    user: {
      attributes: [:id, :name, :avatar, :avatar_timeline, :admin, :admin_current_domain]
    }
  }

  @@show_block = Proc.new {
    if root_object.step.present?
      child :step do
        attributes *[:id, :name, :position]

        child :chapter do
          attributes *[:name, :slug]

          child :course do
            attributes *[:id, :name, :avatar_timeline, :slug]
          end
        end
      end
    end

    node :answers_info do |obj|
      participating_people = User.where(id: obj.answers.group("user_id").pluck("user_id")).limit(2)
      participating_people_count = obj.answers.group("user_id").count.size

      {
        count: participating_people_count,
        participating_title: I18n.t('views.questions.people_answers', count: participating_people_count),
        users: participating_people.map do |user|
          {
            id: user.id,
            name: user.name,
            avatar: user.avatar.url(:s50x50)
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
end
