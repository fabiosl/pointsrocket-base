module Api
  class AnalyticsController < ApplicationController
    protect_from_forgery with: :null_session
    respond_to :json
    before_action :default_format_json
    before_filter :authenticate_user!
    skip_before_action :verify_authenticity_token

    def default_format_json
      if params[:format].nil?
        request.format = "json"
      end
    end

    def info
      begin
        period, start_date, end_date = AnalyticsInfo.get_correct_period_and_validate_start_and_end_date params["period"], params["start_date"], params["end_date"]
      rescue Exception => e
        render json: {
          error: true,
          message: e.message,
          class: e.class.name,
        }, status: :unprocessable_entity
        return
      end

      begin
        fbAnalytics = FacebookAnalyticsInfo.new(@domain, current_user)
        fbAnalytics.period = period
        if period == "custom"
          fbAnalytics.start_date = start_date
          fbAnalytics.end_date = end_date
        end
        fb_info = fbAnalytics.fetch_info
      rescue Exception => e
        fb_info = {
          error: "true",
          class: e.class.name
        }
      end

      begin
        youtubeAnalytics = YoutubeAnalyticsInfo.new(@domain, current_user)
        youtubeAnalytics.period = period
        if period == "custom"
          youtubeAnalytics.start_date = start_date
          youtubeAnalytics.end_date = end_date
        end
        youtube_info = youtubeAnalytics.fetch_info
      rescue Exception => e
        youtube_info = {
          error: "true",
          class: e.class.name
        }
      end

      begin
        instagramAnalytics = InstagramAnalyticsInfo.new(@domain, current_user)
        instagramAnalytics.period = period
        if period == "custom"
          instagramAnalytics.start_date = start_date
          instagramAnalytics.end_date = end_date
        end
        instagram_info = instagramAnalytics.fetch_info

      rescue Exception => e
        instagram_info = {
          error: "true",
          class: e.class.name
        }
      end

      render json: {
        fb_info: fb_info,
        youtube_info: youtube_info,
        instagram_info: instagram_info,
      }
    end

  end
end
