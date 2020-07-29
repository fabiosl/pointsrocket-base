object @notification
attributes *[
  :id, :notifiable_id, :notifiable_type,
  :created_at, :recipient_id, :action,
  :notification_type
]

node :timestamp do |obj|
  obj.created_at.to_i * 1000
end

child :actor do
  attributes :id, :name

  node :avatar_url do |obj|
    obj.avatar.url :small
  end
end

node :is_read do |obj|
  obj.read_at ? true : false
end

child :recipient => :recipient do
  attributes :id, :name, :avatar, :avatar_timeline, :admin, :admin_current_domain
end

if root_object.notifiable.present?
  notifiable_class_name = root_object.notifiable.class.name.underscore
  notifiable_class_name_plural = notifiable_class_name.pluralize

  begin
    helper = (root_object.class.name.pluralize + "Helper").constantize
  rescue Exception => e
    helper = nil
  end

  child :notifiable => :notifiable do
    template_name = "api/#{notifiable_class_name_plural}/_#{notifiable_class_name}"

    if File.exists? Rails.root.join("app/views", template_name + '.rabl')
      extends template_name
    elsif helper
      extends "api/base/_item"
    end

  end

end
