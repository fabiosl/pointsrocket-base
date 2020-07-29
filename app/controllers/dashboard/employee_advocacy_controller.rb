class Dashboard::EmployeeAdvocacyController < DashboardController
  def index
    @dashboard_data = {
      challenge_posts_count: HashtagChallengeUser.count,
      total_likes: HashtagChallengeUser.total_likes,
      points_evolution: PointsEvolutionFlow.new(current_user).get('all', 'weekly'),
      top_engaged_users: User.top_engaged,
      least_engaged_users: User.least_engaged,
      top_engagement_posts: HashtagChallengeUserDecorator
                              .decorate_collection(HashtagChallengeUser.top_engagement_posts),
      worst_performing_posts: EmployeeAdvocacyPost.worst_performing_posts
    }
  end
end