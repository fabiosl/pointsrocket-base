class UserDecorator < Draper::Decorator
  delegate_all

  def ranking_points
    if object.respond_to? :sum_points_value
      return object.sum_points_value
    end

    return object.sum_points
  end

  def formatted_name
    "#{object.name}"
  end

  def formatted_badge_date(badge)
    object.badge_achievment_date(badge).strftime("%d/%m/%Y")
  end

  def domain_access_partial(domain)
    return 'domains/access/allowed' if object.admin || object.in_domain?(domain)
    return 'domains/access/waiting' if object.community_invites.where(domain: domain).waiting_approval.any?
    'domains/access/none'
  end
end
