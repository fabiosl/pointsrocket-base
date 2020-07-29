class MembershipService
  def self.grant_acess_to_user! domain, user
    Membership.where(domain: domain, user: user).first_or_create do |membership|
      membership.role = 'user'
    end
  end
end
