class ResetUserCoinsWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options queue: :default, retry: true, backtrace: true

  def perform(tenant_name, user_id)
    domain = Domain.find_by(subdomain: tenant_name)

    Apartment::Tenant.switch(tenant_name) do
      user = User.find(user_id)
      if domain.peer_recognition_enabled?
        PeerRecognitionPointsMailer.new_peer_recognition_points_email(domain, user).deliver
        update_user_available_coins(user, domain.weekly_user_coins)
        create_user_notification(user, domain)
      end
    end
  end

  private

  def update_user_available_coins(user, num_coins)
    user.available_coins = num_coins
    user.save!
  end

  def create_user_notification(user, domain)
    Notification.create!(
      action: 'reset_weekly_user_coins',
      notifiable: domain,
      recipient: user
    )
  end
end
