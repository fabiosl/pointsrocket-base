class LeaderboardFlow

  def get period
    case period
    when "daily"
      return daily_report
    else
      raise Exception.new("Period not found => #{period}")
    end
  end

  private

    def daily_report
      report Time.now.beginning_of_day..Time.now.end_of_day
    end

    def report range
      User.all.joins(:points).where(points: {created_at: range}).select(
        'users.*, sum(points.id), sum(points.value) as sum_points')
      .group('users.id').order('SUM(points.value) desc')
    end
end
