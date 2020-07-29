class TwoHundredVisitsOnAllPosts < VisitsOnPost

  def run
    employee_advocacy_visit = @args.first
    user = employee_advocacy_visit.employee_advocacy_share.user

    visit_count = user.employee_advocacy_visits.new_visit.count

    if visit_count >= 200
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

  def badge_slug
    "two-hundred-clicks-on-all-posts"
  end
end
