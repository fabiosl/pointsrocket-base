class SelectSocialAccountsController < ApplicationController
  before_action :authenticate_user!
  layout "domains"

  def index
    begin
      @fb_pages = get_fb_pages

      only_page_ids = @fb_pages.map {|p| p["id"]}

      if not current_user.facebook_page_id_to_monitor.present? or not only_page_ids.include? current_user.facebook_page_id_to_monitor
        current_user.facebook_page_id_to_monitor = only_page_ids.first
        current_user.save
      end
    rescue GraphFacebookPages::NoToken => e
      @fb_user_has_no_token = true
    rescue GraphFacebookPages::UserHasChangedPasswordException => e
      @user_has_changed_password_exception = true
    rescue GraphFacebookPages::NoPermissionGranted => e
      @fb_user_has_no_permission = true
    rescue GraphFacebookPages::NoPagesFound => e
      @fb_user_has_no_pages = true
    rescue Exception => e
      @fb_exception = true
    end

    begin
      @yt_channels = get_yt_channels

      only_channel_ids = @yt_channels.map {|c| c["id"]}

      if not current_user.youtube_channel_id_to_monitor.present? or not only_channel_ids.include? current_user.youtube_channel_id_to_monitor
        current_user.youtube_channel_id_to_monitor = only_channel_ids.first
        current_user.save
      end

    rescue GoogleHelper::NoIdentityFound => e
      @yt_user_has_no_token = true
    rescue YoutubeApiHelper::NoPermissionGranted => e
      @yt_user_has_no_permission = true
    rescue YoutubeApiHelper::NoChannelsFound => e
      @yt_user_has_no_channels = true
    rescue Google::Apis::AuthorizationError => e
      @yt_authorization_error = true
    rescue Exception => e
      @yt_exception = true
    end
  end

  def create

    if params["facebook_page_id_to_monitor"].present?
      current_user.facebook_page_id_to_monitor = params["facebook_page_id_to_monitor"]
      current_user.save

      begin
        current_user.proccess_facebook_page_info_to_monitor
      rescue Exception => e
        Rails.logger.warn e.message
        Rails.logger.warn e.backtrace
      end
    end

    if params["youtube_channel_id_to_monitor"].present?
      current_user.youtube_channel_id_to_monitor = params["youtube_channel_id_to_monitor"]
      current_user.save
      begin
        current_user.proccess_youtube_channel_info_to_monitor
      rescue Exception => e
        Rails.logger.warn e.message
        Rails.logger.warn e.backtrace
      end
    end

    if current_user.save
      flash[:alert] = t '.success'

      if ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'true'
        default_url = domains_url(subdomain: nil)
      else
        default_url = dashboard_path
      end

      redirect_url = session[:back_url] || default_url
      session[:back_url] = nil

      redirect_to redirect_url
    else
      flash[:alert] = t '.error'
      redirect_to(select_social_accounts_index_path)
    end

  end

  def get_fb_pages
    Sidekiq.redis do |redis|
      if redis.get("#{current_user.id}_fb_pages_cache").present?
        return JSON.parse redis.get("#{current_user.id}_fb_pages_cache")
      else
        pages = GraphFacebookPages.new(current_user).get_pages
        redis.set("#{current_user.id}_fb_pages_cache", pages.to_json)
        redis.expire("#{current_user.id}_fb_pages_cache", 15.minutes.to_i)
        return pages
      end
    end
  end

  def get_yt_channels
    Sidekiq.redis do |redis|
      if redis.get("#{current_user.id}_yt_channels_cache").present?
        return JSON.parse redis.get("#{current_user.id}_yt_channels_cache")
      else
        channels = YoutubeApiHelper.new(current_user, @domain).get_channels
        redis.set("#{current_user.id}_yt_channels_cache", channels.to_json)
        redis.expire("#{current_user.id}_yt_channels_cache", 15.minutes.to_i)
        return JSON.parse channels.to_json
      end
    end
  end

end
