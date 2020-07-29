class Moip::SubscriptionFlow
  class SubscriptionError < Exception ; end

  def initialize subscription
    @subscription = subscription
  end

  def create
    raise Exception unless @subscription.user.moip_code
    params = @subscription.moip_attributes
    response = create_on_moip params

    if response[:success]
      @subscription.moip_code = params[:code]
      @subscription.save
      @subscription.set_first_paid_day_from_now
      @subscription.calculate_suspend_in_and_active_until
    else
      raise SubscriptionError.new(response)
    end

    update_details_from_moip

    {success: true}
  end

  def suspend
    begin
      response = Moip::Assinaturas::Subscription.suspend(@subscription.moip_code)
    rescue Moip::Assinaturas::WebServerResponseError => e
      p "Não pode suspender a assinatura de id #{@subscription.id} e id no moip #{@subscription.moip_code}. Razão -> #{e.message}"
      return false
    end
    update_details_from_moip
    response
  end

  def activate
    begin
      response = Moip::Assinaturas::Subscription.activate(@subscription.moip_code)
    rescue Moip::Assinaturas::WebServerResponseError => e
      p "Não pode ativar a assinatura de id #{@subscription.id} e id no moip #{@subscription.moip_code}. Razão -> #{e.message}"
      return false
    end

    begin
      franchisee = @subscription.user.get_franchisee
      response = Moip::Assinaturas::Subscription.update(@subscription.moip_code, amount: ENV['FRANCHISEE_DEFAULT_PRICE'].to_i)
    rescue ActiveRecord::RecordNotFound => e
    rescue Moip::Assinaturas::WebServerResponseError => e
      p "Não pode alterar o valor (voucher) da assinatura de id #{@subscription.id} e id no moip #{@subscription.moip_code}. Razão -> #{e.message}"
      return false
    end

    @subscription.calculate_suspend_in_and_active_until
    update_details_from_moip
    response
  end

  def details
    raise unless @subscription.moip_code
    Moip::Assinaturas::Subscription.details(@subscription.moip_code)
  end

  def update_details_from_moip
    response = details

    if response[:success]
      @subscription.update_from_moip(response[:subscription])
    end
  end

  # create on moip and returns subscription code
  def create_on_moip params
    Moip::Assinaturas::Subscription.create(params)
  end

  def get_and_save_moip_invoices
    response = get_moip_invoices
    @subscription.save_invoices(response[:invoices])
  end

  def get_moip_invoices
    Moip::Assinaturas::Invoice.list(@subscription.moip_code)
  end
end
