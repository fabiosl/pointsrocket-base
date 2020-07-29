class Dashboard::ConversationsController < DashboardController
  before_action :set_conversation, only: [:show]

  def index
    @conversations = current_user.conversations
    @users = User.all

    respond_to do |format|
      format.html
      format.json { render "index" }
    end
  end

  def show
    authorize! :read, @conversation
    render json: @conversation, serializer: ConversationSerializer
  end

  def create
    @conversation = Conversation.find_or_create(conversation_params)

    if @conversation.valid?
      render :show, status: :created
    else
      render json: { errors: @conversation.errors.full_messages },
                   status: :unprocessable_entity
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  def conversation_params
    params.require(:conversation).permit(:sender_id, :recipient_id)
  end
end
