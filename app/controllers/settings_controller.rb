class SettingsController < ApplicationController
  before_action :authenticate_user!
  layout 'domains'

  def index
  end

  def update
    if user_params[:current_password]
      current_user.update_with_password(user_params)
    else
      current_user.update_without_password(user_params)
    end

    # isso aqui meio que n ta fazendo o eveito que esta no
    # dashboard/dashboard_controller
    sign_in(current_user, :bypass => true)

    if current_user.valid?
      flash[:success] = I18n.t('controllers.settings.update.success')
    else
      flash.now[:danger] = I18n.t('controllers.settings.update.error')
    end

    redirect_to root_settings_path
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :avatar, :delete_avatar, :location, :website, :bio, :username,
      :lang, :timezone, :country, :see_sensitive_media, :mark_sensitive_media,
      :current_password, :password, :password_confirmation, :renew, :cancel_reason,
      :email, :locale, :phone, :interest_category_list => [],
      :interest_topic_list => []
    )
  end
end
