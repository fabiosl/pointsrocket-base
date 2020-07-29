class WarnUserCoinsExpirationWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options queue: :default, retry: true, backtrace: true

  def perform(tenant_name, user_id)
    domain = Domain.find_by(subdomain: tenant_name)

    Apartment::Tenant.switch(tenant_name) do
      user = User.find(user_id)
      if user.available_coins > 0 and domain.peer_recognition_enabled?
        PeerRecognitionPointsMailer.expiration_peer_recognition_points_email(domain, user).deliver
        create_user_notification(user, domain)
      end
    end
  end

  private

  def create_user_notification(user, domain)
    Notification.create!(
      action: 'expiration_warning',
      notifiable_type: 'CoinGive',
      recipient: user
    )
  end
end
