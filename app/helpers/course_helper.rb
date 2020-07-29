module CourseHelper

  def next_step_for(course, user)
    course.chapters.each do |chapter|
      chapter.steps.order(position: :asc).each do |step|
        if not UserStep.where(user: user, step: step).present?
          return course_chapter_step_path(step.chapter.course.slug,
            step.chapter.slug, step.position)
        end
      end
    end

    return course
  end
end
