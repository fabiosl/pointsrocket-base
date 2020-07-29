 class Moip::RegistrationFlow
  def initialize user
    @user = user
  end

  def register!
    client_flow = Moip::ClientFlow.new(@user)
    client_flow.create
    credit_card_response = client_flow.update_credit_card({
      credit_card: @user.credit_cards.last.moip_attributes
    })

    if not credit_card_response[:success]
      return credit_card_response
    end

    subscription = @user.subscriptions.first

    unless subscription
      subscription = @user.subscriptions.create!
    end

    subscription_flow = Moip::SubscriptionFlow.new(subscription)

    if not subscription.created_on_moip?
      subscription_flow.create
    else
      subscription_flow.activate
    end

    subscription.not_renew = false
    subscription.suspended_in = nil
    subscription.save

    subscription_flow.get_and_save_moip_invoices

    Rails.logger.info "Evento importante: Usuário #{@user.name} #{@user.email} #{@user.phone} realizou um pagamento"

    {:success => true}
  end
end
