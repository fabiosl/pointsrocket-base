hpr = (root_object.class.name.pluralize + "Helper").constantize
# hpr = @base_hpr

attributes *(hpr.show_attributes - hpr.images_attributes)

hpr.images_attributes.each do |attribute|
  node "#{attribute}_url" do |obj|
    versions = obj.send(attribute).versions.keys
    version_permiteds = [:thumb, :small, :s100x109].select do |version|
      versions.include? version
    end

    if version_permiteds.size > 0
      obj.send(attribute).url(version_permiteds.first)
    end
  end
end

if hpr.respond_to? :belongs
  hpr.belongs.keys.each do |key|
    child key do
      attributes *hpr.belongs[key][:attributes]
    end
  end
end

if hpr.respond_to?(:show_block) and hpr.show_block.present?
  instance_eval(&hpr.show_block)
end

node :type do |object|
  object.class.name
end

# if self.respond_to? :nesteds
#   nesteds.keys.each do |key|
#     node key do |obj|
#       obj[nesteds[key]].map do |nested_obj|
#         nesteds[key][:fields].keys.reduce({}) do |memo, nested_key|
#           memo[nested_key] = nested_obj[nested_key]
#           memo
#         end
#       end
#     end
#   end
# end
