class Dashboard::MessagesController < DashboardController
  before_action :set_conversation, except: [:unread]

  def index
    @messages = @conversation.messages.all

    render json: @messages
  end

  def create
    message = @conversation.messages.build(message_params)
    message.user = current_user

    if message.save
      message.notify_and_mail
      render json: message
    else
      render json: { errors: message.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def unread
    render json: { messages: current_user.unread_messages }
  end

  def read_all
    @conversation.messages
                 .not_sent_by(current_user)
                 .unread
                 .update_all(read_at: Time.zone.now)

    head :no_content
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
