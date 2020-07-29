class WeekPostCombo < BrBadge

  def run
    employee_advocacy_share = @args.first
    user = employee_advocacy_share.user

    post_time = employee_advocacy_share.created_at

    begin_of_post_week = post_time.beginning_of_week
    end_of_post_week = post_time.end_of_week

    datetime_ranges = weeks_count.times.map do |i|
      (begin_of_post_week - i.week)..(end_of_post_week - i.week)
    end

    has_post_last_week = datetime_ranges.map do |range|
      user.employee_advocacy_shares.where({
        created_at: range
      }).count > 0
    end.select do |has_post_in_range_week|
      has_post_in_range_week == false
    end.size == 0

    if has_post_last_week
      badge = Badge.where(slug: badge_slug).first

      if badge.present?
        if not user.has_badge? badge
          user.add_badge badge
          user.generate_sum_points
          @badges_added << badge
        end
      end
    end

  end

  def weeks_count
    raise "You should override this method"
  end

  def badge_slug
    raise "You should override this method"
  end

end
