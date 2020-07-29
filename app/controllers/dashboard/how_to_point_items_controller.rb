class Dashboard::HowToPointItemsController < DashboardController

  def index
    authorize! :points, current_user
    badges = Badge.all
    domain_points = @domain.how_to_point_items

    @items = domain_points.map do |domain_point|
      {
        section: domain_point.section,
        points: domain_point.points,
        description: domain_point.description
      }
    end

    @items += badge_items
    @items += challenge_items
    @items += hashtag_challenges_items
    @items += course_items
    @items += broadcast_items

    @items.sort! { |a, b| a[:points] <=> b[:points] }
  end


  private

  def badge_items
    Badge.all.map do |badge|
      {
        section: I18n.t('controllers.dashboard.how_to_point.badge'),
        points: badge.badge_points,
        description: badge.hint || badge.name
      }
    end
  end

  def challenge_items
    Challenge.all.map do |challenge|
      {
        section: I18n.t('controllers.dashboard.how_to_point.challenge'),
        points: challenge.points,
        description: challenge.title
      }
    end
  end

  def hashtag_challenges_items
    HashtagChallenge.all.map do |challenge|
      {
        section: I18n.t('controllers.dashboard.how_to_point.hashtag_challenge'),
        points: challenge.points,
        description: challenge.title
      }
    end
  end

  def course_items
    Course.all.map do |course|
      {
        section: I18n.t('controllers.dashboard.how_to_point.course'),
        points: course.points,
        description: course.name
      }
    end
  end

  def broadcast_items
    Broadcast.all.map do |broadcast|
      {
        section: I18n.t('controllers.dashboard.how_to_point.broadcast'),
        points: broadcast.points,
        description: broadcast.title
      }
    end
  end
end
