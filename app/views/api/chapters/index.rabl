collection @chapters
attributes :id, :name, :description

child :ordered_steps do
  attributes :id, :name, :url, :description, :position, :step_type, :score

  child :ordered_step_questions do
    attributes :id, :question, :hint, :score, :position

    child :step_question_options do
      attributes :id, :content, :correct
    end
  end

  child :archives do
    attributes :id

    node :archive_name do |archive|
      archive.archive.url.split('/').last if archive.archive.present?
    end

    node :archive_url do |archive|
      archive.archive.url if archive.archive.present?
    end
  end
end
