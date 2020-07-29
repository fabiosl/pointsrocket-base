class RewardsFlow
  def initialize user
    @user = user
  end

  def info
    Campaign.all.order(
      'created_at desc').map do |campaign|
      {
        campaign: campaign,
        percentage: get_percentage(campaign) * 100,
        first_users_has_won: users_has_won(campaign, 3),
        users_has_won_count: users_has_won(campaign).count,
      }
    end
  end

  def users_has_won campaign, limit=nil
    if limit == nil
      campaign.users.not_admin
    else
      campaign.users.not_admin.limit(limit)
    end
  end

  def get_percentage campaign
    total_badges = campaign.campaign_badges.count
    if total_badges == 0
      return 0.0
    end
    conquisted_badges = campaign.campaign_badges.select do |campaign_badge|
      @user.has_badge? campaign_badge.badge
    end.size

    conquisted_badges.to_f / total_badges
  end
end
