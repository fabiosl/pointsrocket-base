class ApplicationController < ActionController::Base
  include Mobylette::RespondToMobileRequests
  skip_before_filter :handle_mobile


  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :store_current_location, :unless => :devise_controller?

  before_action :set_locale
  before_action :current_domain
  helper_method :apply_feedback
  helper :providers

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html do
        flash[:error] = I18n.t('controllers.application.forbidden_action')
        redirect_to :back
      end
    end
  end

  rescue_from Apartment::TenantNotFound do
    render file: 'public/404.html', status: 404, layout: false
  end

  # rescue_from Exception do
  #   render template: 'error/internal_error', layout: false
  # end

  def current_user
    UserDecorator.decorate(super) unless super.nil?
  end

  def current_ability
    @current_ability ||= Ability.new(current_user.model)
  end

  helper_method :current_domain
  helper_method :must_show_expired_token_alert?

  def current_domain
    @domain ||= Domain.find_by(subdomain: Apartment::Tenant.current) ||
                Domain.find_by(url: request.protocol + request.host_with_port) ||
                Domain.find_by(default: true)

    session['current_domain_id'] = @domain.id
    @decorated_domain ||= @domain.decorate
  end

  def after_sign_in_path_for(resource)
    after_sign_or_signup_path_for resource
  end

  def must_return_to_user_return_to_url?
    user_return_to_url = session["user_return_to_url"] || ""
    must_return = session["user_return_to_url"].present?

    if current_domain.after_signin_path.present? and current_domain.after_signin_path != 'null'
      if ['', '/'].include?(user_return_to_url.gsub(current_domain.url, ''))
        false
      else
        must_return
      end
    else
      must_return
    end
  end

  def after_sign_or_signup_path_for user
    if session[:take_over_ref]
      to_return = session[:take_over_ref]
      session[:take_over_ref] = nil
      return to_return
    end

    if session['user_has_been_created'].present? or not current_user.registration_complete? or current_user.must_alter_password
      session['user_has_been_created'] = nil
      return complete_registration_path
    end

    if session[:back_url].present?
      back_url = session[:back_url]
      session[:back_url] = nil
      return back_url

    elsif must_return_to_user_return_to_url?
      return_to = session['user_return_to_url']
      session['user_return_to_url'] = nil
      return return_to

    else
      session['user_has_been_created'] = nil
      session['user_return_to_url'] = nil

      if request.host_with_port == ENV['MASTER_DOMAIN']
        if ENV['SUBDOMAIN_AS_COMMUNITIES'] != 'true' and not user.admin
          flash[:alert] = "You must be admin to log in here."
          sign_out user
        end

        return domains_path
      else
        if current_domain.after_signin_path.present? and current_domain.after_signin_path != 'null'
          return current_domain.after_signin_path
        end

        if ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'true'
          domains_url(subdomain: false)
        else
          dashboard_path
        end
      end
    end
  end

  def set_locale
    if current_user and current_user.locale.present?
      user_locale_sym = current_user.try(:locale).to_sym
    else
      langs = (request.env['HTTP_ACCEPT_LANGUAGE'] || "").split(',').map do |item|
        item.split(';').first
      end

      # priority to pt br if browser accepts

      if langs.include? "pt-BR"
        user_locale_sym = :"pt-BR"
      elsif langs.include? "pt-PT"
        # bit sonae
        user_locale_sym = :"en"
      else
        langs = langs.select do |lang|
          I18n.available_locales.include?(lang.to_sym)
        end

        langs << :en

        user_locale_sym = langs.first

        if current_user.present?
          current_user.locale = user_locale_sym
          current_user.save
        end
      end
    end

    return unless I18n.available_locales.include?(user_locale_sym)

    I18n.locale = user_locale_sym
  end

  def set_invite_from_session
    if session[:invite_id].present?
      begin
        @invite_from_session = Invite.find(session[:invite_id])
      rescue ActiveRecord::RecordNotFound => e
        session[:invite_id] = nil
      end
    end
  end

  def apply_feedback key
    if not current_domain.present?
      return key
    end

    if current_domain.challenge_localize_key.present?
      key.gsub("challenge", current_domain.challenge_localize_key)
    else
      key
    end
  end

  def current_user_has_expired_token?
    if ENV['SUBDOMAIN_AS_COMMUNITIES'] != 'false'
      has_expired = current_user.identities.where(token_invalid: true).any?
    else
      has_expired = [:instagram, :google_oauth2, :facebook].any? do |social|
        current_user.identities.where(token_invalid: true, domain: current_domain.master_domain_or_self_for_provider(social)).any?
      end
    end

    if not has_expired and current_user.has_sent_access_token_expired_mail
      current_user.has_sent_access_token_expired_mail = false
      current_user.save
    end

    has_expired
  end

  def must_show_expired_token_alert?
    current_user_has_expired_token?
  end

  def store_current_location
    if request.get? and is_navigational_format?
      if not request.url.include?('.json') and not request.url.include?('invites') and not request.params[:controller].starts_with?('api/')
        session['user_return_to_url'] = request.url
      end
    end
  end
end
