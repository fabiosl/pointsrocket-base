class Dashboard::QuestionsController < DashboardController
  before_action :set_question, except: [:create, :upvote, :downvote]
  before_action :set_question_2, only: [:upvote, :downvote]

  load_and_authorize_resource
  skip_authorize_resource only: [:create, :show]

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    @step = @question.step

    if @question.save

      if @question.step
        @question.tags = @step.chapter.course.tags
        @question.save
      end

      if @question.tags.count == 0
        @question.tags = current_user.tags
        @question.save
      end

      flash[:success] = "Pergunta criada com sucesso"
      msg = "Pergunta criada: Usuário #{current_user.name} (id: #{current_user.id})"
      msg = "#{msg} - pergunta: #{@question.title} - link #{question_url(@question)}"
      Rails.logger.info msg

      badge = Badge.where(slug: "aprendiz-do-forum").first
      current_user.add_badge(badge)

      if @question.step.nil?
        redirect_to forum_path
      else
        redirect_to course_chapter_step_path(@step.chapter.course.slug,
          @step.chapter.slug, @step.position)
      end
    else
      flash[:error] = "Não foi possível cadastrar a sua pergunta, tente novamente"

      if @question.step.nil?
        redirect_to forum_path
      else
        redirect_to course_chapter_step_path(@step.chapter.course.slug,
          @step.chapter.slug, @step.position)
      end
    end
  end

  def show
    @answer = Answer.new
  end

  def edit
  end

  def update
    if @question.update(question_params)
      flash[:success] = "Pergunta atualizada com sucesso"
      redirect_to @question
    else
      flash[:error] = "Não foi possível atualizar a sua pergunta, tente novamente"
      redirect_to @question
    end
  end

  def destroy
    if @question.destroy
      flash[:success] = "Pergunta removida com sucesso"
      redirect_to forum_path
    else
      flash[:error] = "Não foi possível remover a sua pergunta, tente novamente"
      redirect_to forum_path
    end
  end

  def upvote
    VoteFlow.new(current_user).up(@question)
    render :show, status: :ok
  end

  def downvote
    VoteFlow.new(current_user).down(@question)
    render :show, status: :ok
  end

  private

  def set_question
    @question = Question.find(params[:id]).decorate
  end

  def set_question_2
    @question = Question.find(params[:question_id])
  end

  def question_params
    params.require(:question).permit(:step_id, :title, :content, :tag_list, :archive)
  end
end
