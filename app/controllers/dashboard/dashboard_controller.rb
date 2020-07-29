class Dashboard::DashboardController < DashboardController
  def settings
    if request.put?
      if user_params[:current_password]
        current_user.update_with_password(user_params)
      else
        current_user.update_without_password(user_params)
      end

      sign_in(current_user, :bypass => true)

      if current_user.valid?
        flash[:notice] = I18n.t('controllers.dashboard.dashboard.settings.flash.success')
        redirect_to settings_url
      else
        flash.now[:danger] = I18n.t('controllers.dashboard.dashboard.settings.flash.error')
      end
    end
  end

  def cancel
    render json: {text: 'you must provide user[cancel_reason]'}, status: :unprocessable_entity unless user_params[:cancel_reason]

    current_user.cancel_reason = user_params[:cancel_reason]
    current_user.save

    if current_user.subscriptions.trial.any?
      message = I18n.t('controllers.dashboard.dashboard.settings.cancel.success')
    else
      message = I18n.t('controllers.dashboard.dashboard.settings.cancel.cancel')
    end

    current_user.subscriptions.each do |subscription|
      CancelFlow.new(subscription).cancel
    end

    flash[:notice] = message
    if request.xhr?
      render json: {text: message}
    else
      redirect_to :back
    end
  end

  def activate
    message = I18n.t('controllers.dashboard.dashboard.activate.success')

    current_user.subscriptions.each do |subscription|
      ActivateFlow.new(subscription).activate
    end

    flash[:notice] = message
    redirect_to :back
  end

  def unauth
  end
end
