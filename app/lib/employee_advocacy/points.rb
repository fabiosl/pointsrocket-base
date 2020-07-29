class EmployeeAdvocacy::Points

  attr_reader :points_added

  def initialize employee_advocacy_share
    @employee_advocacy_share = employee_advocacy_share
  end

  def add_points!
    social = @employee_advocacy_share.social_network
    employee_advocacy_post = @employee_advocacy_share.employee_advocacy_post
    user = @employee_advocacy_share.user

    if user.points.where(pointable: @employee_advocacy_share).any?
      @points_added = false
    else
      @points_added = true
      value = employee_advocacy_post["#{social}_points"]
      user.points.create(
        pointable: @employee_advocacy_share,
        value: value,
        emit: true
      )
    end
  end
end

