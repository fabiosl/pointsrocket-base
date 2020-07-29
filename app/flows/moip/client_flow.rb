class Moip::ClientFlow
  def initialize user
    @user = user
  end

  def create

    if not @user.moip_code
      moip_response = create_on_moip
      if moip_response[:success]
        @user.moip_code = moip_response[:code]
      end

      @user.save!
    end
  end

  # create on moip and returns user code
  def create_on_moip
    customer_params = @user.moip_attributes

    response = Moip::Assinaturas::Customer.create(customer_params, new_valt=false)

    if response[:success]
      {
        success: true,
        code: customer_params['code'],
      }
    else
      response
    end
  end

  def update_credit_card credit_card
    Moip::Assinaturas::Customer.update_credit_card(@user.moip_code, credit_card)
  end


end
