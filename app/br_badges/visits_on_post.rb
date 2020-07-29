class VisitsOnPost < BrBadge
  def run
    employee_advocacy_visit = @args.first
    user = employee_advocacy_visit.employee_advocacy_share.user

    user_shares = EmployeeAdvocacyShare.where(user: user, employee_advocacy_post_id: employee_advocacy_visit.employee_advocacy_share.employee_advocacy_post_id)

    visit_count = user_shares.inject(0) do |memo, share|
      memo + share.employee_advocacy_visits.new_visit.count
    end

    if visit_count >= min_visits_count
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

  def min_visits_count
    raise "You should override this method"
  end

  def badge_slug
    raise "You should override this method"
    # "ten-clicks-on-post"
  end
end
