class Dashboard::PointsController < DashboardController

  before_action :set_user

  def index
    authorize! :points, current_user
    @points = @user.points.order('created_at desc')

    if params['date'].present?
      if ['last_24_hours', 'last_7_days', 'last_month'].include? params['date']
        @points = @points.send(params['date'])
      end
    end

    @points = @points.paginate(page: params[:page])
  end

    private

    def set_user
      if params[:user_id].present?
        @user = User.find params[:user_id]
      else
        @user = current_user
      end
    end
end
