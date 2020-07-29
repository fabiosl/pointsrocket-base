class Dashboard::TimelineController < DashboardController
  def index
    @timeline_data = {
      leaderboard: LeaderboardFlow.new.get("daily"),
      questions: Question.all.order('created_at desc').limit(3),
      badge_users: BadgesFlow.new(current_user).last(3),
      rewards: RewardsFlow.new(current_user).info,
      goals_info: GoalsFlow.new.info(current_user.tags),
      post: Post.new,
      pending_activities_count: activities_items(pending: true).size,
    }

    @activities = activities_items
  end

  def carousel_activities
    activities
  end

  def activities
    @items_id = params[:items_id]
    page = [params[:page].to_i, 1].max
    items_per_page = 10
    @activities ||= activities_items

    @total_pages = activities_total_pages(@activities.size.to_f, items_per_page)

    @activities_has_next_items = activities_has_next_items(
      @activities.size, items_per_page, page
    )

    @activities = @activities.drop((page - 1) * items_per_page).take(items_per_page)

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def activities_items opt={}
    [].concat(Badge.all.order("created_at desc"))
      .concat(Broadcast.all.order("created_at desc"))
      .concat(Challenge.all.order("created_at desc"))
      .concat(Course.all.order("created_at desc"))
      .concat(
        (current_domain.employee_advocacy_enabled ? EmployeeAdvocacyPost.all.order("created_at desc") : [])
      )
      .concat(HashtagChallenge.all.order("created_at desc"))
      .select {|activity|
        if params[:pending] || opt[:pending]
          ! activity.done_by_user?(current_user)
        else
          true
        end
      }
      .sort_by { |a| [(a.done_by_user?(current_user) ? 1 : 0), - a.created_at.to_i] }
      #.sort_by{ |x| [Date.today - x.created_at.to_date] }
      #.sort_by { |activity| activity.done_by_user?(current_user) ? 1 : 0 }
      #.sort { |a, b| b.created_at <=> a.created_at }
  end

  def activities_has_next_items(items_count, items_per_page, page)
    page < activities_total_pages(items_count, items_per_page)
  end

  def activities_total_pages(items_count, items_per_page)
    (items_count.to_f / items_per_page).ceil
  end
end
