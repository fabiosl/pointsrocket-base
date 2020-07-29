class EmployeeAdvocacySharesController < ApplicationController

  before_action :set_employee_advocacy_share, only: [:show, :update]

  def show
    render layout: nil
  end

  def update
    ids_visiteds = (session[:ids_visiteds] || '').split(',')

    visit_flow = EmployeeAdvocacyVisitFlow.new(
      @employee_advocacy_share,
      ids_visiteds
    )

    visit = visit_flow.visit()
    TriggerEvent.new.run "employee_advocacy_visit", @domain, visit

    if visit.new_visit
      TriggerEvent.new.run "employee_advocacy_new_visit", @domain, visit
      # EmployeeAdvocacy::VisitPoints.new(visit).add_points
    end
    session[:ids_visiteds] = visit_flow.ids_visiteds.join(',')
    render nothing: true
  end

  private

    def set_employee_advocacy_share
      @employee_advocacy_share = EmployeeAdvocacyShare.find(params['id']).decorate
    end

end
