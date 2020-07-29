class Ability
  include CanCan::Ability
  prepend Draper::CanCanCan

  def initialize(user)
    can :see_dashboard, Domain, dashboard_enabled: true
    can :see_courses, Domain, courses_enabled: true
    can :see_forum, Domain, forum_enabled: true
    can :create, Vote
    # isso aqui trocado pra modify funcionar, mas não funciona
    can [:update, :destroy], Vote, user_id: user.id

    can :create, Comment

    if user.admin
      can [:update, :destroy], Comment
    else
      can [:update, :destroy], Comment, user_id: user.id
    end

    can [:update, :destroy], ChallengeUser, user_id: user.id

    can [:update, :destroy], [Question, Answer], user_id: user.id
    can [:users, :user_badges, :see_formatted_names, :manage_notifications,
      :manage_sites, :see_email_preview, :kpi, :loreal], User, admin: true

    can [:manage_all_domains], User, can_manage_all_domains: true

    can [:associate], Badge, admin: true
    can [:badges, :points, :indication, :campaigns], User
    can [:tags_options], User do
      user.tags.count >= 2
    end
    can [:trivias], User do
      ENV['TRIVIAS_ENABLED'] == 'true'
    end
    can [:change_credit_card], User do
      user.active_to_use_app?
    end

    can [:upvote, :downvote], [Question, Answer] do |item|
      item.user_id != user.id
    end

    if user.admin
      can [:update, :create, :destroy], EmployeeAdvocacyPost
      can :manage, Membership
      can :create, Domain
      can :destroy, Domain
      can :generate_token, User
    end

    can [:index, :show, :folders], EmployeeAdvocacyPost

    can :create, ExternalAction

    can :manage, EmployeeAdvocacyShare, user_id: user.id

    can :manage, Membership do |membership|
      user.admin_domain?(membership.domain)
    end

    can [:manage_community, :notify_users, :manage_timeline], Domain do |domain|
      user.admin_current_domain
    end

    can :create_posts, Domain do |domain|
      user.admin_current_domain || domain.any_user_can_post?
    end

    can :create_news, Domain do |domain|
      domain.employee_advocacy_enabled && user.admin
    end

    can :give_points, Domain do |domain|
      domain.peer_recognition_enabled
    end

    can :manage, Post do |post|
      user.admin || post.user_id == user.id
    end

    can :read_submissions, Challenge do |challenge|
      user.admin || challenge.privacy == 'all'
    end

    can :read, Conversation do |conversation|
      conversation.sender_id == user.id || conversation.recipient_id == user.id
    end

    can :report_content, Domain, allow_content_report: true
  end
end
