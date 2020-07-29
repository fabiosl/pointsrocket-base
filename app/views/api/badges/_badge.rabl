object @badge
attributes *[
  :id, :name, :badgeable_id, :badgeable_type, :badge_points, :badge_type, :hint
]

node :avatar_url do |obj|
  obj.avatar.url :s100x109
end

node :badgeable_name do |obj|
  if obj.badgeable.respond_to? :name
    obj.badgeable.name
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
