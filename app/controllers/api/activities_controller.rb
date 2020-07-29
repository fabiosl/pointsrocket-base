module Api
  class ActivitiesController < Api::BaseController
    before_filter :authenticate_user!
    skip_before_action :verify_authenticity_token

    def index
      page = [params[:page].to_i, 1].max
      items_per_page = 10
      @activities ||= activities_items

      @total_pages = activities_total_pages(@activities.size.to_f, items_per_page)

      @activities_has_next_items = activities_has_next_items(
        @activities.size, items_per_page, page
      )

      @activities = @activities.drop((page - 1) * items_per_page).take(items_per_page)
    end

    def activities_items opt={}
      [].concat(Badge.all.order("created_at desc"))
        .concat(Broadcast.all.order("created_at desc"))
        .concat(Challenge.all.order("created_at desc"))
        .concat(Course.all.order("created_at desc"))
        .concat(
          (current_domain.employee_advocacy_enabled ? EmployeeAdvocacyPost.all.order("created_at desc") : [])
        )
        .concat(HashtagChallenge.all.order("created_at desc"))
        .map do |activity|
          {
            done_by_user: activity.done_by_user?(current_user),
            activity: activity
          }
        end
        .select {|activity|
          if params[:pending] || opt[:pending]
            ! activity[:done_by_user]
          else
            true
          end
        }
        .sort_by { |a| [(a[:done_by_user] ? 1 : 0), - a[:activity].created_at.to_i] }
    end

    def activities_has_next_items(items_count, items_per_page, page)
      page < activities_total_pages(items_count, items_per_page)
    end

    def activities_total_pages(items_count, items_per_page)
      (items_count.to_f / items_per_page).ceil
    end

  end
end
