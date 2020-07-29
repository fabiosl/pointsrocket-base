object @trail
attributes *[
  :id,
  :name,
  :description,
  :hours,
  :age_group,
  :video_url,
  :position,
  :active,
]

child :course_trails do
  attributes :id, :course_id

  # child :course do
  #   extends "api/courses/course"
  # end
end


child :category_links do
  attributes :id, :category_id

  # child :course do
  #   extends "api/courses/course"
  # end
end
