class Dashboard::SuperAdminController < DashboardController
  def index
    @domains = Domain.all
  end
end
