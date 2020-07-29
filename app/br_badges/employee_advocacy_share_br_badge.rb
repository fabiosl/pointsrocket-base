class EmployeeAdvocacyShareBrBadge < BrBadge
  def run
    employee_advocacy_share = @args.first
    user = employee_advocacy_share.user

    badge = Badge.where(slug: badge_slug).first

    if badge.present?
      if not user.has_badge? badge
        user.add_badge badge
        user.generate_sum_points
        @badges_added << badge
      end
    end
  end

  def badge_slug
    raise "You should override this method"
  end
end
