object @course
attributes :id, :name, :slug, :description, :avatar_file_name, :preview_url,
  :active, :monitor_html, :points, :users_finished_count

node :avatar_url do |obj|
  obj.avatar.url :small
end

node :finished_course_badge_url do |obj|
  if obj.current_finished_course_badge.present?
    obj.current_finished_course_badge.avatar.url(:s100x109)
  end
end

node :finish_badge_id do |obj|
  if obj.current_finished_course_badge.present?
    obj.current_finished_course_badge.id
  end
end

node :finish_badge_name do |obj|
  if obj.current_finished_course_badge.present?
    obj.current_finished_course_badge.name
  end
end

node :finish_badge_points do |obj|
  if obj.current_finished_course_badge.present?
    obj.current_finished_course_badge.badge_points
  end
end

if not locals[:for_timeline]
  child :ordered_chapters do
    extends "api/chapters/index"
  end
end

node :videos_count do |obj|
  obj.steps.videos.count
end

node :quizes_count do |obj|
  obj.steps.quizes.count
end

node :steps_count do |obj|
  obj.steps.count
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

node :type do |object|
  object.class.name
end
