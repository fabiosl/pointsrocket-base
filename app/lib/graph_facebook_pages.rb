class GraphFacebookPages
  class DefaultException < Exception ; end
  class NoToken < DefaultException ; end
  class TokenInvalid < DefaultException ; end
  class NoPermissionGranted < DefaultException ; end
  class NoPagesFound < DefaultException ; end
  class FbError < DefaultException ; end
  class UserHasChangedPasswordException < DefaultException ; end

  def initialize user, domain
    @user = user
    @domain = domain
  end

  def token
    if @token.nil?
      if not @user.identities.where(
          domain: @domain.master_domain_or_self_for_provider(:facebook)
        ).facebook.any?
        raise NoToken.new
      end

      identities = @user.identities.where(
        domain: @domain.master_domain_or_self_for_provider(:facebook)
      ).facebook

      if identities.where(token_invalid: true).any? and not identities.where(token_invalid: [false, nil]).any?
        raise TokenInvalid.new("Your account has an invalid identity")
      end

      tokens = identities.where(token_invalid: [false, nil]).pluck('access_token')

      tokens = tokens.select do |token|
        token.present?
      end

      if tokens.size == 0
        raise NoToken.new("Your account has identity, but no token")
      end

      @token = tokens.first
    end

    @token
  end

  def get_pages
    graph = GraphFacebook.new(token)
    response = graph.get_pages

    if not response["data"].nil?
      if response["data"].size > 0
        return response["data"]
      else
        permissions = graph.get_permissions

        permissions["data"].each do |permission|
          if permission["permissions"] == "manage_pages"
            if permission["status"] == "granted"
              raise NoPagesFound.new("You have permission but no pages")
            else
              raise NoPermissionGranted.new(permission)
            end
          end
        end

        raise NoPermissionGranted.new(permissions)
      end
    else
      if response['error']
        if response['error']['code'] == 190 and response['error']['error_subcode'] == 460
          raise UserHasChangedPasswordException.new(response)
        end
      end
      raise FbError.new(response)
    end

    response
  end

end
