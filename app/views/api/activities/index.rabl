collection @activities

node :done_by_user do |hash|
  hash[:done_by_user]
end

node :timestamp do |hash|
  hash[:activity].created_at.to_i
end

node :activity_type do |hash|
  hash[:activity].class.name
end

node :activity do |hash|
  activity = hash[:activity]

  notifiable_class_name = activity.class.name.underscore
  notifiable_class_name_plural = notifiable_class_name.pluralize

  begin
    helper = (activity.class.name.pluralize + "Helper").constantize
  rescue Exception => e
    helper = nil
  end

  template_name = "api/#{notifiable_class_name_plural}/_#{notifiable_class_name}"

  if File.exists? Rails.root.join("app/views", template_name + '.rabl')
    res = partial template_name, object: activity
  elsif helper
    res = partial "api/base/_item", object: activity
  elsif helper
    res = JSON.parse(activity.to_json)
  end

  res
end
