class Dashboard::ChangeCreditCardController < DashboardController

  before_action :set_credit_card, only: :update

  def index
    authorize! :change_credit_card, current_user
    @credit_card = current_user.credit_cards.first
  end

  def update
    authorize! :change_credit_card, current_user
    if @credit_card.update(credit_card_attributes)
      begin
        moip_response = Moip::ClientFlow.new(current_user).update_credit_card(credit_card: @credit_card.moip_attributes)
        if moip_response[:success]
          flash.now[:success] = "Cartão de crédito alterado com sucesso"
        else
          flash.now[:danger] = "Ocorreu um erro ao tentar atualizar os dados do cartão, verifique os dados e tente novamente."
        end
      rescue Moip::Assinaturas::WebServerResponseError => e
        flash.now[:danger] = "Ocorreu um erro ao tentar se conectar ao moip pagamentos, tente novamente mais tarde"
      end
    else
      flash.now[:danger] = "Houve um erro ao tentar atualizar cartão de crédito"
    end

    render :index
  end

  private

    def credit_card_attributes
      params.require(:credit_card).permit([:number, :holder_name, :expiration])
    end

    def set_credit_card
      @credit_card = current_user.credit_cards.first
    end
end
