class Dashboard::CoursesController < DashboardController
  before_action :set_courses
  before_action :set_course, only: :show

  helper_method :get_next_chapter_available, :set_next_chapter_available,
                :get_next_step_available, :set_next_step_available

  def show
    badge_flow = BadgeFlow.new(current_user, @course)
    @finished_badges = badge_flow.check_for_finished_chapters
    course_badge = badge_flow.check_for_finished_course
    @finished_badges << course_badge unless course_badge.nil?
    render 'dashboard/course'
  end

  def course_url
    return "dashboard/#{course.slug}"
  end

  private
    @@next_chapter_available = 0
    @@next_step_available = 0

    ##########################
    # Private methods
    # ========================
    ##########################

    def set_courses
      @courses = Course.all
    end

    def set_course
      @course = @courses.find params[:id]
    end

    def set_next_chapter_available(position)
      @@next_chapter_available = position
    end

    def get_next_chapter_available
      return @@next_chapter_available
    end

    def set_next_step_available(position)
      @@next_step_available = position
    end

    def get_next_step_available
      return @@next_step_available
    end
end
