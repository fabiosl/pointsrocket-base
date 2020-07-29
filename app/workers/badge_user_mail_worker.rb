class BadgeUserMailWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options :queue => :default, :retry => true, backtrace: true

  def perform(domain_id, user_id, badge_user_id)
    domain = Domain.find(domain_id)

    Apartment::Tenant.switch(domain.subdomain) do
      begin
        user = User.find(user_id)
        badge_user = BadgeUser.find(badge_user_id)
      rescue ActiveRecord::RecordNotFound => e
        ap e.message
        return
      end

      BadgeUserMailer.new_badge_email(domain, user, badge_user).deliver if user.subscribe
    end
  end
end
