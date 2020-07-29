class GoalsFlow
  def info goal_tags
    Goal.all.map do |goal|
      {
        goal: goal,
        first_users_hit_goal: hit_goal(goal, 3),
        users_hit_goal_count: hit_goal(goal).size,
      }
    end
  end

  def hit_goal_info goal

    info = User.all.map do |user|
      info_fo_user goal, user
    end

    info
  end

  def info_fo_user goal, user
    to_return = {
      user: user,
      badge_goals_info: []
    }

    badge_goals = goal.badge_goals
    range = Time.now.beginning_of_day..Time.now.end_of_day

    badge_goals.each do |badge_goal|
      if badge_goal.badge.badge_type == 'simple'
        range_user_goal_count = user.badge_users.where(created_at: range, badge: badge_goal.badge).count
      else
        range_user_goal_count = Point.where(pointable: badge_goal.badge, user: user, created_at: range).count
      end

      has_all_badge_for_this_goal = range_user_goal_count >= badge_goal.repetition

      to_return[:badge_goals_info] << {
        badge_goal_id: badge_goal.id,
        badge_id: badge_goal.badge.id,
        has_all_badge_for_this_goal: has_all_badge_for_this_goal,
        range_user_goal_count: range_user_goal_count,
        repetition: badge_goal.repetition
      }
    end

    to_return
  end

  def hit_goal goal, count=nil
    if @users_has_hit_goal_info.nil?
      goal_info = hit_goal_info goal
      @users_has_hit_goal_info = goal_info.select do |goal_info_user|
        goal_info_user[:badge_goals_info].select do |badge_hit_info|
          badge_hit_info[:has_all_badge_for_this_goal] == false
        end.size == 0

      end.map do |goal_info_user|
        goal_info_user[:user]
      end
    end

    to_return = @users_has_hit_goal_info

    if count
      to_return = @users_has_hit_goal_info.take(3)
    end

    to_return
  end
end
