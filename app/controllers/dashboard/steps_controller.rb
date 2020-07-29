class Dashboard::StepsController < DashboardController
  before_action :set_course, except: [:point_video]
  before_action :set_chapter, except: [:point_video]
  before_action :set_steps, except: [:point_video]
  before_action :set_step, only: :show
  before_action :verify_step_watch, only: :show
  before_action :set_show_correct_answer, only: :show
  before_action :add_init_course_badge, except: [:point_video]
  helper_method :get_next_step

  def show
    @question = Question.new
    @step_questions = @step.questions.decorate
  end

  def point_video
    @step = Step.find(params[:id])

    current_user.init_step(@step)
    current_user._add_points(
      value: @step.score || ENV['DEFAULT_STEP_POINTS'].to_i,
      pointable: @step
    )

    render json: @step
  end

  private

  def add_init_course_badge
    badge = Badge.where(slug: "iniciou-um-curso").first
    current_user.add_badge(badge)
  end

  def set_show_correct_answer
    @show_correct_answer = session[:step_correct_answer]
    session[:step_correct_answer] = nil
  end

  def set_course
    @course = Course.find params[:course_id]
  end

  def set_chapter
    @chapter = Chapter.find params[:chapter_id]
  end

  def set_steps
    @steps = Step.all
  end

  def set_step
    @step = @chapter.steps.find_by position: params[:id]
  end

  def get_next_step(step)
    step_chapter = step.chapter
    step_course = step_chapter.course

    for other_step in step.chapter.steps.order position: :asc
      return course_chapter_step_path(other_step.chapter.course.slug,
        other_step.chapter.slug, other_step.position) if other_step.position > step.position
    end

    # TODO: Check chapters against each other based on position not created_at
    step_course.chapters.each do |chapter|
      return course_chapter_step_path(
        chapter.course.slug, chapter.slug, 0
      ) if chapter.created_at > step_chapter.created_at
    end

    url_for(step.chapter.course)
  end

  def verify_step_watch
    if not @step.free and not current_user.active_to_use_app? and not @domain.is_points
      redirect_to blocked_content_path
    end
  end
end
