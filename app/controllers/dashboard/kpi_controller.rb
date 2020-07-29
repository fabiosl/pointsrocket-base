class Dashboard::KpiController < DashboardController
  def index
    authorize! :kpi, current_user
  end

  def colaborador
    authorize! :kpi, current_user
  end

  def admin
    authorize! :kpi, current_user
  end
end
