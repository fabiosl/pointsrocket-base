require "omniauth_setup"

class OmniauthSetupLinkedin < OmniauthSetup

  # Use the subdomain in the request to find the account with credentials
  def custom_credentials
    credentials = default_credentials

    if current_domain(@request)
      domain = current_domain(@request)

      if domain.permit_provider? :linkedin
        credentials.merge!({
          client_id: domain.get_provider_client_id(:linkedin),
          client_secret: domain.get_provider_client_secret(:linkedin)
        })
      end

    end

    credentials
  end

  def default_credentials
    {
      scope: "r_liteprofile r_emailaddress w_member_social",
      fields: ['id', 'email-address', 'first-name', 'last-name', 'headline', 'industry', 'picture-url', 'public-profile-url', 'location'],
      callback_url: user_omniauth_callback_url(:linkedin, host: http_host)
    }
  end
end
