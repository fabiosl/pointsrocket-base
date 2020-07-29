class Dashboard::AdminController < DashboardController
  def index
    authorize! :manage_community, current_domain
  end
end
