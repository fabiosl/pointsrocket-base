class Users::PasswordsController < Devise::PasswordsController
  layout "general"

  def new
    if request.subdomain.present? and ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'true'
      redirect_to new_user_session_url(subdomain: false)
      return
    end
    super

    session[:password_search_in_tenants] = params[:password_search_in_tenants]
    @show_tokens_url = session[:password_search_in_tenants].present?

    self.resource = resource_class.new

    if @domain.present? and @domain.layout.present?
      render "new_#{@domain.layout}", layout: @domain.layout
    end
  end

  def continue_create
    self.resource = resource_class.send_reset_password_instructions_with_options(
      resource_params, domain: Domain.get_current_domain
    )
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      if @domain.present? and @domain.layout.present?
        render "new_#{@domain.layout}", layout: @domain.layout
      end
    end
  end

  def create
    @show_tokens_url = session[:password_search_in_tenants].present?
    if session[:password_search_in_tenants].present?
      Apartment.tenant_names.each do |tenant|
        Apartment::Tenant.switch(tenant) do
          if user = User.find_by(email: resource_params[:email])
            continue_create
            return
          end
        end
      end
    end

    continue_create
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_flashing_format?
      sign_in(resource_name, resource)
      resource.remember_me!
      respond_with resource, location: after_resetting_password_path_for(resource)
    else
      if @domain.present? and @domain.layout.present?
        render "edit_#{@domain.layout}", layout: @domain.layout
      end
    end
  end

  def after_sending_reset_password_instructions_path_for resource
    if session[:password_search_in_tenants].present?
      users_token_login_path
    else
      super
    end
  end

  def edit
    super

    if @domain.present? and @domain.layout.present?
      render "edit_#{@domain.layout}", layout: @domain.layout
    end
  end
end
