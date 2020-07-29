class CoinUserMailWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options queue: :default, retry: 5, backtrace: true

  def perform(tenant, coin_user_id)

    Apartment::Tenant.switch(tenant) do
      coin_user = CoinUser.find coin_user_id
      CoinUserMailer.new_coin_user_email(coin_user).deliver if coin_user.recipient.subscribe
    end
  end
end
