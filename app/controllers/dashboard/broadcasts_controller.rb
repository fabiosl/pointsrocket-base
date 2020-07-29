class Dashboard::BroadcastsController < DashboardController
  before_action :set_broadcast, only: [:show, :comment]

  def index
    @broadcasts = Broadcast.all
  end

  def show
  end

  def comment
    puts params
    @broadcast.comments.build(
      content: params['content'],
      user: current_user,
      emit: true
    )

    if @broadcast.save
      render json: @broadcast
    else
      render json: { errors: @broadcast.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def set_broadcast
    @broadcast = Broadcast.find(params[:id])
  end
end
