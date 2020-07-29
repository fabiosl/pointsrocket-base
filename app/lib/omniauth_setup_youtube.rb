require "omniauth_setup"

class OmniauthSetupYoutube < OmniauthSetup

  # Use the subdomain in the request to find the account with credentials
  def custom_credentials
    credentials = default_credentials

    if current_domain(@request)
      domain = current_domain(@request)

      if domain.permit_provider? :google_oauth2
        credentials.merge!({
          client_id: domain.get_provider_client_id(:google_oauth2),
          client_secret: domain.get_provider_client_secret(:google_oauth2)
        })
      end

    end

    credentials
  end

  def default_credentials
    {
      # scope: "email,profile,youtube"
      scope: "email,profile,https://www.googleapis.com/auth/youtube",
      provider_ignores_state: true,
      redirect_uri: user_omniauth_callback_url(:google_oauth2, host: http_host)
    }
  end
end
