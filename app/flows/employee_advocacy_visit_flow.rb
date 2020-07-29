class EmployeeAdvocacyVisitFlow

  attr_accessor :ids_visiteds
  attr_reader :new_visit

  def initialize employee_advocacy_share, ids_visiteds
    @employee_advocacy_share = employee_advocacy_share
    @ids_visiteds = ids_visiteds
  end

  def visit
    if not @ids_visiteds.present?
      @ids_visiteds = []
    end

    @new_visit = !@ids_visiteds.include?(@employee_advocacy_share.id.to_s)
    visit = @employee_advocacy_share.employee_advocacy_visits.create!(
      new_visit: @new_visit
    )

    if @new_visit
      @ids_visiteds << @employee_advocacy_share.id.to_s

      if @ids_visiteds.length > 10
        @ids_visiteds.shift
      end
    end

    visit
  end
end
