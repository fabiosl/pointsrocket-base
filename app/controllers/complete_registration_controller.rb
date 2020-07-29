class CompleteRegistrationController < ApplicationController
  before_filter :authenticate_user!
  layout "general"

  def index
    @user = current_user
    if request.patch?
      if @user.update(complete_registration_params.merge(has_submited_payment_form: true))
        if not @user.mailed_welcome and @user.email.present?
          # TransactionalMailer.welcome(@user.email).deliver
          @user.mailed_welcome = true
          @user.save
        end
        redirect_to dashboard_path
      else
        flash.now[:danger] = "Não foi possível atualizar o usuário: #{@user.errors.full_messages.join(', ')}"
      end
    end
  end

  def payment
    @plans = Plan.active.order('duration asc')
    @user = current_user
    if request.patch?
      if @user.update(complete_registration_params)
        begin
          registration_response = Moip::RegistrationFlow.new(@user).register!
        rescue Moip::SubscriptionFlow::SubscriptionError => e
          Rails.logger.info e
          Rails.logger.info "Evento importante: Usuário #{current_user.name} #{current_user.email} #{current_user.phone} pagou sem sucesso"

          @user.errors.add(
            :base, "Houve um erro ao salvar os dados do pagamento. Verifique se todos os dados estão corretos. Caso o erro persistir, entre em contato conosco imediatamente."
          )
        end
        if registration_response and registration_response[:success]
          redirect_to action: :success
        else
          Rails.logger.info "Evento importante: Usuário #{current_user.name} #{current_user.email} #{current_user.phone} pagou sem sucesso"

          @user.errors.add(
            :base, "Houve um erro ao salvar os dados do pagamento. Verifique se todos os dados estão corretos. Caso o erro persistir, entre em contato conosco imediatamente."
          )
        end
      end
    elsif request.post?
      if params['voucher'].present?
        @voucher_code = params['voucher']
        begin
          franchisee = Franchisee.where(token: @voucher_code).first
          if not franchisee.present?
            raise ActiveRecord::RecordNotFound
          end
          current_user.voucher = @voucher_code
          current_user.save
          Rails.logger.info "Evento importante: Usuário #{current_user.name} #{current_user.email} #{current_user.phone} usou um voucher da franquia (#{franchisee.id}) com sucesso"
          flash.now[:success] = "Voucher ativo com sucesso!"
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.info "Evento importante: Usuário #{current_user.name} #{current_user.email} #{current_user.phone} usou um voucher (#{@voucher_code}) sem sucesso"
          flash.now[:danger] = "Voucher não encontrado!"
        end
      end
    end

    if not request.patch?
      @user.addresses.build unless @user.addresses.any?
      @user.credit_cards.build unless @user.credit_cards.any?
    end

    if request.get?
      Rails.logger.info "Evento importante: Usuário #{current_user.name} #{current_user.email} #{current_user.phone} chegou na tela do pagamento"
    end

    find_franchisee
  end

  def clear_voucher
    current_user.voucher = nil
    current_user.save
    flash[:success] = "Voucher removido com sucesso!"

    begin
      redirect_to :back
    rescue ActionController::RedirectBackError => e
      redirect_to root_path
    end
  end

  def success
    @subscription = current_user.subscriptions.last
    # render layout: "application"
  end

  private

  # def find_voucher
  #   @voucher = Voucher.find session[:voucher_id]
  # end

  def find_franchisee
    begin
      @franchisee = current_user.get_franchisee
    rescue ActiveRecord::RecordNotFound => e
      @franchisee = nil
    end
  end

  def check_subscription
    if current_user.subscriptions.active_or_trial.any?
      redirect_to dashboard_path
    end
  end

  def complete_registration_params
    the_params = params.require(:user).permit([
      :id,
      :name,
      :cpf,
      :phone,
      :birthdate,
      :plan_id,
      :email,
      :credit_cards_attributes => [
        :id,
        :holder_name,
        :number,
        :expiration
      ],
      :addresses_attributes => [
        :id,
        :street,
        :number,
        :complement,
        :district,
        :city,
        :state,
        :country,
        :zipcode,
        :user_id
      ]
    ])

    the_params
  end
end
