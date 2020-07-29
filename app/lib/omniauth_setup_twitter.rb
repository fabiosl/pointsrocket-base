require "omniauth_setup"

class OmniauthSetupTwitter < OmniauthSetup

  # Use the subdomain in the request to find the account with credentials
  def custom_credentials
    credentials = default_credentials

    if current_domain(@request)
      domain = current_domain(@request)

      if domain.permit_provider? :twitter
        credentials.merge!({
          consumer_key: domain.get_provider_client_id(:twitter),
          consumer_secret: domain.get_provider_client_secret(:twitter)
        })
      end
    end

    credentials
  end

  def default_credentials
    {
      callback_url: user_omniauth_callback_url(:twitter, host: http_host)
    }
  end
end
