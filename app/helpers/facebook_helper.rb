module FacebookHelper
  extend ActiveSupport::Concern

  class NoIdentityFound < Exception ; end

  def self.get_access_token user, domain
    if not user.identities.facebook.any?
      raise NoIdentityFound.new("No facebook identity found for user #{user.id}")
    end

    user.identities.facebook.first.access_token
  end

end
