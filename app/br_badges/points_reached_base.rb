class PointsReachedBase < BrBadge

  def run
    point = @args.first
    user = point.user

    if user.sum_points >= points_value
      begin
        badge = Badge.find_by slug: badge_slug
        raise ActiveRecord::RecordNotFound if badge.nil?

        if not user.has_badge? badge
          user.add_badge badge
          user.generate_sum_points
          @badges_added << badge
          TriggerEvent.new.run "new_point", @domain, point
        end
      rescue ActiveRecord::RecordNotFound => e
        ap e.message
        ap e.backtrace
      end
    end


  end

  def points_value
    raise "Override"
  end

  def badge_slug
    raise "Override"
  end
end
