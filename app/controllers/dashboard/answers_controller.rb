class Dashboard::AnswersController < DashboardController
  before_action :set_answer, except: [:create, :upvote, :downvote]
  before_action :set_answer_2, only: [:upvote, :downvote]

  load_and_authorize_resource
  skip_authorize_resource only: [:create]

  def create
    @answer = Answer.new(answer_params)

    begin
      @question = Question.find(params[:answer][:question_id])
    rescue Exception => e
      @question = nil
    end

    @answer.question = @question
    @answer.user = current_user

    if @answer.save
      Notification.create!(
        recipient: @question.user,
        actor: current_user,
        action: 'create',
        notifiable: @answer
      )

      flash[:success] = "Resposta criada com sucesso"
      msg = "Resposta criada: Usuário #{current_user.name} (id: #{current_user.id})"
      msg = "#{msg} - resposta: #{@answer.content} - link da pergunta #{question_url(@answer.question)}"

      Rails.logger.info msg

      badge = Badge.where(slug: "aprendiz-do-forum").first
      current_user.add_badge(badge)
      redirect_to @question
    else
      flash[:error] = "Não foi possível cadastrar a sua resposta, tente novamente"
      redirect_to forum_path
    end
  end

  def edit
    @question = @answer.question
  end

  def update
    @question = @answer.question

    if @answer.update(answer_params)
      flash[:success] = "Resposta atualizada com sucesso"
      redirect_to @question
    else
      flash[:error] = "Não foi possível atualizar a sua resposta, tente novamente"
      redirect_to @question
    end
  end

  def destroy
    if @answer.destroy
      flash[:success] = "Resposta removida com sucesso"
      redirect_to question_path(@answer.question)
    else
      flash[:error] = "Não foi possível remover a sua resposta, tente novamente"
      redirect_to question_path(@answer.question)
    end
  end

  def upvote
    VoteFlow.new(current_user).up(@answer)
    render :show, status: :created
  end

  def downvote
    VoteFlow.new(current_user).down(@answer)
    render :show, status: :created
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_answer_2
    @answer = Answer.find(params[:answer_id])
  end

  def answer_params
    params.require(:answer).permit(:content, :archive)
  end
end
