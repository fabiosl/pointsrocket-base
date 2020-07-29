require "omniauth_setup"

class OmniauthSetupFacebook < OmniauthSetup

  # Use the subdomain in the request to find the account with credentials
  def custom_credentials
    credentials = default_credentials

    if current_domain(@request)
      domain = current_domain(@request)

      if domain.permit_provider? :facebook
        credentials.merge!({
          client_id: domain.get_provider_client_id(:facebook),
          client_secret: domain.get_provider_client_secret(:facebook)
        })
      end
    end

    credentials
  end

  def default_credentials
    scopes = (ENV['FACEBOOK_SCOPE'] || '').split(',')

    to_return = {
      client_id: ENV['FACEBOOK_APP_ID'],
      client_secret: ENV['FACEBOOK_APP_SECRET'],
      info_fields: "name,email,id,verified",
      callback_url: user_omniauth_callback_url(:facebook, host: http_host)
    }

    if domain = current_domain(@request)
      if domain.hashtag_challenges_enabled
        scopes << 'manage_pages'
      end

      if domain.share_in_personal
        scopes << 'publish_pages'
        scopes << 'manage_pages'
      end
    end

    if @request.params[:more_scopes].present?
      scopes += @request.params[:more_scopes].split(',')
    end

    to_return[:scope] = scopes.join(',')

    to_return
  end
end
