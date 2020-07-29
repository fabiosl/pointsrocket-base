class Dashboard::ForumController < DashboardController
  QUESTION_FILTERS = {
    "answered" => lambda { |r| r.with_answers },
    "not_answered" => lambda { |r| r.without_answers },
    "new" => lambda { |r| r.limit(10) }
  }

  QUESTION_FILTERS.default = lambda { |r| r.all }

  def index
    authorize! :see_forum, @domain
    @question = Question.new
    @questions = get_questions.decorate
  end

  private

  def get_questions
    begin
      Course.find(params[:course])
      result = Question.joins(step: :chapter).where("chapters.course_id" => params[:course])
    rescue Exception => e
      result = Question.all
    end

    begin
      Step.find(params[:tag])
      result = result.where("step_id" => params[:tag])
    rescue Exception => e
      result
    end

    result = result.where.not(
      user_id: current_user.block_users.pluck(:blocked_id))

    filter = QUESTION_FILTERS[params[:filter]]
    result = filter.call(result)

    result
  end
end
