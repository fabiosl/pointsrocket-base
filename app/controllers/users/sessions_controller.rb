class Users::SessionsController < Devise::SessionsController
  layout "general"

  def new
    if request.format == 'json'
      redirect_to new_user_session_path
      return
    end

    if request.subdomain.present? and ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'true'
      redirect_to new_user_session_url(subdomain: false)
      return
    end
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)

    if @domain.present? and @domain.layout.present?
      render "new_#{@domain.layout}", layout: @domain.layout
    end
  end
end
