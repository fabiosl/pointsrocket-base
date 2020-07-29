class BadgeFlow

  def initialize(user, course)
    @user = user
    @course = course
  end

  def check_for_finished_chapters
    finished_chapters_badges = []

    @course.chapters.each do |chapter|
      chapter_badge = chapter.badge

      if chapter_badge and @user.completed_chapter?(chapter)
        badge = @user.add_badge(chapter_badge)
        finished_chapters_badges << badge unless badge.nil?
      end
    end

    return finished_chapters_badges
  end

  def check_for_finished_course
    course_badge = Badge.find_by_name_and_badgeable_type("Curso de #{@course.name} finalizado", "Course")
    if course_badge.present? and @user.finished_course?(@course)
      if @user.has_badge?(course_badge)
        finished_course_badge = course_badge
      else
        finished_course_badge = @user.add_badge(course_badge)
      end
    end

    return finished_course_badge
  end
end
