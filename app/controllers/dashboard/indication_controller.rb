class Dashboard::IndicationController < DashboardController

  def index
    authorize! :indication, current_user
  end
end
