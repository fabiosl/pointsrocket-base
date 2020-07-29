class Dashboard::QuestionAnswersController < DashboardController
  def create
    @question_answer = current_user.question_answers.where(
      step_question_id: question_answer_params[:step_question_id]
    ).first_or_initialize
    @question_answer.update_attributes(question_answer_params)
    @question_answer.save

    if @question_answer.valid?
      if @question_answer.step_question_option.correct?
        @step = StepQuestion.find(question_answer_params[:step_question_id]).step
        current_user.init_step(@step) if current_user.finished_quiz?(@step)

        if not @question_answer.score_added
          current_user._add_points(
            value: @question_answer.step_question.score || ENV['DEFAULT_STEP_QUESTION_POINTS'].to_i,
            pointable: @question_answer.step_question
          )
          @question_answer.score_added = true
          @question_answer.save
        end
      end
    else
      redirect_to :back and return
    end

    render :show
  end

  private

    def question_answer_params
      params.require(:question_answer).permit(
        :step_question_id, :step_question_option_id
      )
    end
end
