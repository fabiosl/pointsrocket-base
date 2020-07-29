class Dashboard::LorealController < DashboardController
  def index
    authorize! :loreal, current_user
  end

  def colaborador
    authorize! :loreal, current_user
  end

  def admin
    authorize! :loreal, current_user
  end
end
