attributes *[
  :id, :created_at, :updated_at, :timelineable_type, :pinned
]

node :time do |obj|
  if obj.timelineable.respond_to?(:created_at)
    distance_of_time_in_words_to_now obj.timelineable.created_at
  else
    distance_of_time_in_words_to_now obj.created_at
  end
end

if root_object.timelineable.present?
  timelineable_class_name = root_object.timelineable.class.name.underscore
  timelineable_class_name_plural = timelineable_class_name.pluralize

  begin
    helper = (root_object.timelineable.class.name.pluralize + "Helper").constantize
  rescue Exception => e
    helper = nil
  end

  child :timelineable => :timelineable do
    template_name = "api/#{timelineable_class_name_plural}/_#{timelineable_class_name}"

    if File.exists? Rails.root.join("app/views", template_name + '.rabl')
      extends template_name, locals: { for_timeline: true }
    elsif helper
      extends "api/base/_item", locals: { for_timeline: true }
    end
  end

end
