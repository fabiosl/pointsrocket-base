object @campaign
attributes *[
  :id, :title, :subtitle, :description,
  :start_date, :end_date, :slug,
  :redeem_points, :max_redeems, :redeem_points?
]

node :formatted_start_date do |obj|
  obj.start_date.strftime("%d/%m/%Y") if obj.end_date.present?
end

node :formatted_end_date do |obj|
  obj.end_date.strftime("%d/%m/%Y") if obj.end_date.present?
end

node :image_url_campaign_index do |obj|
  obj.image.url :campaign_index
end

node :image_url do |obj|
  obj.image.url :thumb
end

node :image_url_redeem do |obj|
  obj.image.url :redeem
end

node :has_participants? do |obj|
  obj.users.not_admin.size > 0
end

child :campaign_badges do
  attributes :id

  child :badge do
    attributes :id, :name
  end
end

node :participants do |obj|
  to_return = {
    count: obj.users.not_admin.size,
    items: obj.users.not_admin.limit(5).map do |user|
      {
        id: user.id,
        name: user.name,
        avatar: user.avatar,
        admin: user.admin
      }
    end
  }

  if obj.redeem_points.present?
    to_return[:label] = "#{I18n.t('views.general.users.redeemed', count: obj.users.not_admin.size)}"
  else
    to_return[:label] = "#{I18n.t('views.general.users.joined', count: obj.users.not_admin.size)}"
  end

  to_return
end

node :campaign_users_info do |obj|
  {
    count: obj.campaign_users.count,
    participating_title: "#{pluralize obj.campaign_users.count, "pessoa está participando", "pessoas estão participando"}",
    users: obj.campaign_users.limit(2).map do |campaign_user|
      user = campaign_user.user
      if user.present?
        {
          name: user.name,
          avatar: user.avatar.url(:s50x50),
        }
      else
        {
          name: "",
          avatar: "",
        }
      end
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

node :type do |object|
  object.class.name
end

