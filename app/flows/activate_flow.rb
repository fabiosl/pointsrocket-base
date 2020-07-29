class ActivateFlow
  def initialize subscription
    @subscription = subscription
  end

  def activate
    _activate_on_moip
    _set_params_for_active_account
  end

  def _set_params_for_active_account
    @subscription.suspended_in = nil
    @subscription.not_renew = false
    @subscription.save
  end

  def _activate_on_moip
    Moip::SubscriptionFlow.new(@subscription).activate
  end

end
