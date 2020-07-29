require "omniauth_setup"

class OmniauthSetupInstagram < OmniauthSetup

  # Use the subdomain in the request to find the account with credentials
  def custom_credentials
    credentials = default_credentials

    if current_domain(@request)
      domain = current_domain(@request)

      if domain.permit_provider? :instagram
        credentials.merge!({
          client_id: domain.get_provider_client_id(:instagram),
          client_secret: domain.get_provider_client_secret(:instagram)
        })
      end
    end

    credentials
  end

  def default_credentials
    if ENV['INSTAGRAM_SCOPE'].present?
      {
        scope: ENV['INSTAGRAM_SCOPE'].split(",").join(" "),
        callback_url: user_omniauth_callback_url(:instagram, host: http_host)
      }
    else
      {
        callback_url: user_omniauth_callback_url(:instagram, host: http_host)
      }
    end
  end
end
