class SuspendSubscriptionNotRenewFlow
  def initialize subscription
    @subscription = subscription
  end

  def self.run_for_all_subscriptions
    Subscription.all.each do |subscription|
      if subscription.ready_to_suspend?
        SuspendSubscriptionNotRenewFlow.suspend! subscription
      end
    end
  end

  def self.suspend! subscription
    SuspendSubscriptionNotRenewFlow.new(subscription).suspend!
  end

  def suspend!
    _suspend_on_moip!
    _update_suspended_in!
  end

  # suspender a assinatura no moip
  def _suspend_on_moip!
    Moip::SubscriptionFlow.new(@subscription).suspend
  end

  # seta o atributo suspended_in
  def _update_suspended_in!
    @subscription.suspended_in = Time.now
    @subscription.save
  end
end
