class Users::TokensLoginController < Devise::SessionsController
  layout 'general'

  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    render 'new_token'
  end

  def create
    invite_info = invite_info(params[:token])

    if invite_info
      redirect_to "#{invite_info[:domain].get_url}#{invite_token_path(invite_info[:invite].token)}"
    else
      flash[:danger] = I18n.t('controllers.token.invalid')
      redirect_to :back
    end
  end

  def get_return_url
    user = valid_user(params[:user])

    if user
      user.generate_token_login!
      domain = Domain.get_current_domain
      return "#{domain.get_url}#{token_login_api_tokens_path}?token=#{user.token_login}"
    end
  end

  def login
    if ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'false'
      Apartment.tenant_names.each do |tenant|
        return_url = nil
        Apartment::Tenant.switch(tenant) do
          return_url = get_return_url
          break if return_url.present?
        end

        if return_url.present?
          redirect_to return_url
          return
        end
      end
    else
      return_url = get_return_url
      if return_url.present?
        redirect_to return_url
        return
      end
    end


    flash[:info] = I18n.t('devise.failure.invalid', authentication_keys: :email)
    redirect_to users_token_login_path
  end

  private

  def invite_info(token_key)
    Apartment.tenant_names.each do |tenant|
      Apartment::Tenant.switch(tenant) do
        if invite = Invite.find_by(token: token_key)
          return {
            invite: invite,
            domain: Domain.find_by(subdomain: tenant)
          }
        end
      end
    end
    nil
  end

  def valid_user(params)
    user = User.find_by(email: params[:email])
    user && user.valid_password?(params[:password]) ? user : nil
  end
end
