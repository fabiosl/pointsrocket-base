if @employee_advocacy_share
  @employee_advocacy_share.decorate
end

object @employee_advocacy_share

attributes *[
  :id, :social_network, :user_content, :schedule_date, :shared_date, :token,
  :points_added, :interaction_count, :created_at, :formatted_created_at,
]

child :employee_advocacy_post do |item|
  attributes :id, :title, :content, :url

  node :image do |post|
    post.image.url
  end
end

node :social_json do |item|
  JSON.parse(item.social_json || "[]").map do |i|
    i.slice("employee_shared_at", "link")
  end
end

child :user do
  attributes :id, :name, :avatar, :avatar_timeline, :admin_current_domain
end

node :user_id do |item|
  if item.user
    item.user.id
  end
end

node :user_name do |item|
  if item.user
    item.user.name
  end
end

node :user_avatar do |item|
  if item.user
    item.user.avatar.url(:s34x34)
  end
end

node :visit_count do |item|
  if item.user
    item.employee_advocacy_visits.new_visit.count
  end
end

node :external_url do |item|
  item.decorate.external_url
end

if @badges_added.present?
  child @badges_added => :badges_added do
    extends "api/badges/index"
  end
end
