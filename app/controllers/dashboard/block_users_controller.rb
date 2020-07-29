class Dashboard::BlockUsersController < DashboardController
  before_action :set_block_user, only: [:destroy]

  def index
    @block_users = current_user.block_users
    @block_user = BlockUser.new
  end

  def create
    @block_user = BlockUser.new(block_user_params)

    if @block_user.save
      redirect_to :back, notice: I18n.t("controllers.dashboard.block_users.successfully")
    else
      @block_users = current_user.block_users
      flash.now[:error] = I18n.t("controllers.dashboard.block_users.error")
      render :index
    end
  end

  def destroy
    @block_user.destroy
    flash[:alert] = I18n.t('controllers.application.unblocked_successfully')
    redirect_to :back
  end

  private

    def set_block_user
      @block_user = current_user.block_users.find params[:id]
    end

    def block_user_params
      p = params.require(:block_user).permit(:blocked_id)
      p.merge! blocker_id: current_user.id
    end
end
