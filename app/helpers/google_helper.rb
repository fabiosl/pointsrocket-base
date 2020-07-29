require 'signet/oauth_2/client'

module GoogleHelper
  extend ActiveSupport::Concern

  class NoIdentityFound < Exception ; end
  class TokenInvalid < Exception ; end

  def self.authorization domain
    domain = domain.master_domain_or_self_for_provider :google_oauth2
    auth = Signet::OAuth2::Client.new
    auth.client_id = domain.youtube_app_id
    auth.client_secret = domain.youtube_app_secret
    auth.authorization_uri = 'https://accounts.google.com/o/oauth2/auth'
    auth.token_credential_uri = 'https://accounts.google.com/o/oauth2/token'
    # auth.redirect_uri = "http://lvh.me:3000/users/auth/google_oauth2/callback"

    auth
  end

  def self.authorization_for_user user, domain
    domain = domain.master_domain_or_self_for_provider :google_oauth2
    auth = authorization domain

    if not user.identities.youtube.where(domain: domain).any?
      raise NoIdentityFound.new("No youtube identity found for user #{user.id}")
    end

    identities = user.identities.youtube.where(domain: domain)
    if identities.where(token_invalid: true).any? and not identities.where(token_invalid: [false, nil]).any?
      raise TokenInvalid.new("Your account has an invalid identity")
    end

    identity = identities.where(token_invalid: [false, nil]).first

    refresh_token = identity.get_refresh_token
    if refresh_token
      auth.refresh_token = refresh_token
    end

    auth.access_token = identity.access_token
    auth.expires_at = identity.json["credentials"]["expires_at"]

    auth
  end

end
