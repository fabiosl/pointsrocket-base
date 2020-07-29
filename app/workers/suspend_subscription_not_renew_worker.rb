class SuspendSubscriptionNotRenewWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options :queue => :default, :retry => false

  def perform
    SuspendSubscriptionNotRenewFlow.run_for_all_subscriptions
  end

end
