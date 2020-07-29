class BadgesFlow
  def initialize user
    @user = user
  end

  def last count
    @user.badge_users.order('created_at desc').limit(count)
  end
end
