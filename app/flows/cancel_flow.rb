class CancelFlow
  def initialize subscription
    @subscription = subscription
  end

  def cancel
    if @subscription.trial_period?
      _suspend_on_moip
    elsif @subscription.active_period?
      _set_subscription_to_not_renew
    end
  end

  def _suspend_on_moip
    Moip::SubscriptionFlow.new(@subscription).suspend
  end

  def _set_subscription_to_not_renew
    @subscription.not_renew = true
    @subscription.save
  end
end
