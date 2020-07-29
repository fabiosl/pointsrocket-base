class EmployeeAdvocacy::VisitPoints

  def initialize employee_advocacy_visit
    @employee_advocacy_visit = employee_advocacy_visit
  end

  def add_points
    employee_advocacy_share = @employee_advocacy_visit.employee_advocacy_share
    first_visit = employee_advocacy_share.employee_advocacy_visits.order('id asc').first
    user = employee_advocacy_share.user

    point = user.points.where(pointable: first_visit).first_or_create
    point.value += 1
    point.save
    user.generate_sum_points
    point
  end

end

