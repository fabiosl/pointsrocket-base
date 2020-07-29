class PointsEvolutionFlow
  attr_accessor :points_time_range
  attr_accessor :fill_empty_with_zeros

  def initialize user
    @user = user
  end

  def timeline_points_evolution
    self.points_time_range = 5.days.ago.to_datetime..Time.now
    self.fill_empty_with_zeros = true
    get("all", "daily")
  end

  def get period, group
    points = get_points_by_period period
    group_points points, group
  end

  def group_points points, group
    case group
    when "daily"
      date_trunc = 'day'
      diff = 1
    when "weekly"
      date_trunc = 'week'
      diff = 7
    when "monthly"
      date_trunc = 'month'
      diff = 30
    else
      raise Exception.new("Group not found => #{group}")
    end

    result = points.group(
      "date_trunc('#{date_trunc}', created_at at time zone '-03')")

    # if @where_query
    #   result = @where_query.call result
    # end

    result = result.sum("value")

    dates = result.keys.sort
    first = dates.first
    last = dates.last

    if fill_empty_with_zeros && points_time_range
      points_time_range.step(diff).each do |timestamp|
        datetime = Time.at(timestamp).to_date
        if not dates.include? datetime
          result[datetime] = 0
        end
      end
    end

    result
  end

  def get_points_by_period period
    if not @points_time_range
      case period
      when "this_month"
        @points_time_range = Time.now.beginning_of_month..Time.now.end_of_month
      when "this_year"
        @points_time_range = Time.now.beginning_of_year..Time.now.end_of_year
      when "all"
        @points_time_range = nil
      else
        raise Exception.new("Period not found => #{period}")
      end
    end

    points = @user.points

    if @points_time_range
      points = points.where(created_at: @points_time_range)
    end

    points
  end
end
