class RegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_current_user_registration

  layout 'domains'

  # TO-DO: Remove this action duplication (vide select_social_accounts_controller)
  def complete
    if ENV['SUBDOMAIN_AS_COMMUNITIES'] != 'false'
      @it_token_invalid = current_user.identities.instagram.where(token_invalid: true).any?
    else
      @it_token_invalid = current_user.identities.where(token_invalid: true, domain: @domain.master_domain_or_self_for_provider(:instagram)).any?
    end

    begin
      @fb_pages = CacheFacebookPage.get_fb_pages current_user

      only_page_ids = @fb_pages.map {|p| p["id"]}

      if not current_user.facebook_page_id_to_monitor.present? or not only_page_ids.include? current_user.facebook_page_id_to_monitor
        current_user.facebook_page_id_to_monitor = only_page_ids.first
        current_user.save
      end
    rescue GraphFacebookPages::NoToken => e
      @fb_user_has_no_token = true
    rescue GraphFacebookPages::UserHasChangedPasswordException => e
      @user_has_changed_password_exception = true
    rescue GraphFacebookPages::TokenInvalid => e
      @fb_token_invalid = true
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
    rescue GoogleHelper::TokenInvalid => e
      @yt_token_invalid = true
    rescue YoutubeApiHelper::NoPermissionGranted => e
      @yt_user_has_no_permission = true
    rescue YoutubeApiHelper::NoChannelsFound => e
      @yt_user_has_no_channels = true
    rescue Google::Apis::AuthorizationError => e
      @yt_authorization_error = true
    rescue Signet::AuthorizationError => e
      @yt_token_invalid = true
    rescue Exception => e
      @yt_exception = true
    end
  end

  def update
    if user_params[:current_password]
      current_user.update_with_password(user_params)
    else
      current_user.update_without_password(user_params)
    end

    if user_params[:email].present? and user_params[:email].starts_with?('change@me')
      flash[:danger] = I18n.t('devise.registrations.set_valid_mail_change_me')
      complete
      @error_type = 'user'
      render :complete
      return
    end

    if current_user.must_alter_password
      if not user_params[:password].present?
        flash[:danger] = I18n.t('devise.registrations.set_password_error')
        complete
        @error_type = 'user'
        render :complete
        return
      elsif user_params[:password] != user_params[:password_confirmation]
        flash[:danger] = I18n.t('devise.passwords.password_confirmation_failure')
        complete
        @error_type = 'user'
        render :complete
        return
      else
        current_user.must_alter_password = false
      end
    end

    current_user.update_pages_and_run_collect current_domain
    current_user.registration_complete = true
    current_user.save

    if current_user.valid?

      flash[:success] = I18n.t('controllers.registrations.complete.success')

      if ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'true'
        to_redirect = domains_url(subdomain: nil)
      else
        to_redirect = dashboard_path
      end
      to_redirect = params['ref'] || to_redirect

      redirect_to to_redirect
    else
      flash[:danger] = I18n.t('controllers.registrations.complete.error')
      complete
      render :complete
    end

  end

  private

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

  def user_params
    params
      .require(:user)
      .permit(
        :name, :avatar, :delete_avatar, :location, :website, :bio, :username,
        :lang, :timezone, :country, :see_sensitive_media, :mark_sensitive_media,
        :current_password, :password, :password_confirmation, :renew, :cancel_reason,
        :email, :locale, :phone,
        :facebook_page_id_to_monitor, :youtube_channel_id_to_monitor,
        :facebook_page_id_to_monitor, :youtube_channel_id_to_monitor,
        :complete_account_question_option_ids,
        :complete_account_question_option_ids => []
      )

  end

  def check_current_user_registration
    return if params["edit_social_networks"].present?

    if ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'true'
      the_redirect = domains_url(subdomain: false)
    else
      the_redirect = dashboard_path
    end
    return redirect_to the_redirect if current_user.registration_complete? and not current_user.must_alter_password
  end
end
