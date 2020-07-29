module Api
  class EmployeeAdvocacyPostsController < Api::BaseController
    include ActionView::Helpers::DateHelper

    before_filter :authenticate_user!
    skip_before_action :verify_authenticity_token
    load_and_authorize_resource

    def index
      where = {}
      where["folder"] = params["folder"] if params["folder"].present?

      page_index = (page_params[:page] || 1).to_i - 1

      min_period_asc = (ENV["ADVOCACY_MIN_PERIOD_DAYS"] || "14").to_i.days.ago.to_datetime.beginning_of_day

      groups = EmployeeAdvocacyPost.where(where)
        .pluck("id,valid_until,created_at")
        .group_by do |id, valid_until, created_at|
          date = valid_until || created_at
          date >= min_period_asc ? "asc" : "desc"
        end

      aux = (groups["asc"] || []).sort_by do |id, valid_until, created_at|
        valid_until || created_at
      end

      aux += (groups["desc"] || []).sort_by do |id, valid_until, created_at|
        valid_until || created_at
      end.reverse

      aux = aux.in_groups_of(24)[page_index] || []

      ids = aux.select(&:present?).map do |id, created_at, valid_until|
        id
      end

      @employee_advocacy_posts = EmployeeAdvocacyPost.where(id: ids).order('created_at DESC')
    end

    def folders
      advocacies = EmployeeAdvocacyPost.group("folder").count

      by_folder = advocacies.map do |folder, count|
        last_update = EmployeeAdvocacyPost\
          .where(folder: folder)\
          .pluck("valid_until,created_at")\
          .flatten.select(&:present?).max

        diff_update = last_update ? distance_of_time_in_words_to_now(last_update) : nil

        {
          folder: folder,
          count: count,
          last_update: last_update,
          diff_update: diff_update
        }
      end.sort_by do |h|
        h[:last_update] || 1.year.ago.to_datetime
      end.reverse

      render json: by_folder
    end

    def create
      super

      if get_resource.persisted? && params['notify_users']
        User.all.each do |user|
          DeliverEmployeeMailWorker.perform_in(
            1.minute,
            user.id,
            get_resource.id,
            Apartment::Tenant.current
          )
        end
      end
    end

    private

    def employee_advocacy_post_params
      the_params = params.require(:employee_advocacy_post).permit(
        :id,
        :active,
        :facebook_points,
        :twitter_points,
        :linkedin_points,
        :instagram_points,
        :download_points,
        :title,
        :content,
        :url,
        :image,
        :video,
        :remove_video,
        :remove_image,
        :remote_image_url,
        :folder,
        :valid_until,
        :skip_timeline,
      )
      the_params.merge!(user: current_user)
      the_params
    end
  end
end
