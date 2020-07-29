class Dashboard::BadgesController < DashboardController
  def index
    authorize! :badges, current_user
    @user = current_user
    @badges = Badge.all
  end

  def associate
    @user = User.find(params[:user_id])
    @badge = Badge.find(params[:badge_id])
    @user.add_badge(@badge)
    render :show, status: :ok
  end

  def deassociate
    @user = User.find(params[:user_id])
    @badge = Badge.find(params[:badge_id])
    @user.remove_badge(@badge)
    render json: {}, status: :ok
  end
end
