class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  class NoAuthUserFound < Exception ; end

  def continue_flow provider, from_token_login=false
    begin
      Rails.logger.info "runing find for omniauth"
      @user = User.find_for_oauth(env["omniauth.auth"], current_user, session, params)
    rescue User::OnlyInvitedException => e
      flash[:warning] = t "controllers.users.omniauth_callbacks.must_have_invite"
      if from_token_login
        redirect_to users_token_login_path
      else
        redirect_to new_user_session_path
      end
      return
    end

    Rails.logger.info "end runing find for omniauth"

    session[:take_over] = nil

    if @user.is_a?(Hash)
      if @user[:error_type] == 'has_other_user_associated'
        redirect_to erro_em_adicionar_rede_social_path(email: @user[:identity].user.email, provider: env["omniauth.auth"].provider, ref: after_sign_or_signup_path_for(@user[:identity].user)) and return
      end
    end

    if @user.persisted?
      if from_token_login
        @user.generate_token_login!
        domain = Domain.get_current_domain
        redirect_to "#{domain.get_url}#{token_login_api_tokens_path}?token=#{@user.token_login}"
        return
      end

      @user.remember_me!
      Rails.logger.info "runing badges flor omniauth"
      badge = Badge.find_by_slug('#{provider}-associated')
      @user.add_badge(badge)
      Rails.logger.info "end badges flor omniauth"
      sign_in_and_redirect @user, event: :authentication
      kind = provider.capitalize

      if provider == :google_oauth2
        kind = "Youtube"
      end

      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        if session['from_token_login']
          session['from_token_login'] = nil

          begin
            tenant = find_auth_user_tenant(env["omniauth.auth"])
            Apartment::Tenant.switch(tenant) do
              continue_flow "#{provider}", true
            end

          rescue NoAuthUserFound => e
            flash[:warning] = t "controllers.users.omniauth_callbacks.user_not_found"
            redirect_to token_login_path
            return
          end
        else
          continue_flow "#{provider}"
        end
      end
    }
  end

  def passthru_with_session
    if params['ref']
      session[:back_url] = params['ref']
    elsif request.referer
      session[:back_url] = request.referer
    end

    redirect_to(user_omniauth_authorize_path(params["provider"]))
  end

  def passthru_with_multi_login
    session["from_token_login"] = true
    redirect_to(user_omniauth_authorize_path(params["provider"]))
  end

  def passthru_with_take_over
    session[:take_over] = "true"
    session[:take_over_ref] = params[:ref]
    redirect_to(user_omniauth_authorize_path(params["provider"]))
  end

  ProvidersHelper.available_providers.each do |provider|
    provides_callback_for provider
  end

  private

  def after_sign_in_path_for(resource)
    after_sign_or_signup_path_for resource
  end

  def find_auth_user_tenant(auth)
    Apartment.tenant_names.each do |tenant|
      Apartment::Tenant.switch(tenant) do
        if Identity.find_by(uid: auth['uid'], provider: auth['provider'])
          return tenant
        end
      end
    end

    raise NoAuthUserFound.new("No auth user found")
  end
end
