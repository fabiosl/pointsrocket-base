class Users::RegistrationsController < Devise::RegistrationsController
  before_action :set_invite_from_session
  before_action :current_domain

  layout "general"

  def new
    if @domain.only_invited?
      if not @invite_from_session.present? or not @invite_from_session.status == 'pending'
        flash[:warning] = t "controllers.users.omniauth_callbacks.must_have_invite"
        redirect_to new_user_session_path
        return
      end
    end
    super
  end

  def create
    if params[:user] and params[:user][:password]
      params[:user][:password_confirmation] = params[:user][:password]
    end

    if @domain.only_invited?
      if not @invite_from_session.present? or not @invite_from_session.status == 'pending'
        flash[:warning] = t "controllers.users.omniauth_callbacks.must_have_invite"
        redirect_to new_user_session_path
        return
      end
    end

    session['user_has_been_created'] = 'true'

    super

    if @user.persisted?
      if @invite_from_session.present?
        @invite_from_session.status = 'created'
        @invite_from_session.save

        MembershipService.grant_acess_to_user! @domain, @user
      end
      session[:invite_id] = nil
    else
      session['user_has_been_created'] = nil
    end
  end

  def update
    flash[:notice] = 'Dados atualizados com sucesso'
    super
  end

  protected

    def after_update_path_for(user)
      request.referer
    end

    def account_update_params
      params.require(:user).permit(
        :name, :avatar, :delete_avatar, :location, :website, :bio, :username, :lang,
        :timezone, :country, :see_sensitive_media, :mark_sensitive_media, :current_password,
        :password, :password_confirmation, :voucher
      )
    end

    def after_sign_up_path_for(user)
      after_sign_or_signup_path_for user
    end

    def update_resource(resource, params)
      resource.update_without_password(params)
    end

    def sign_up_params
      to_return = params.require(:user).permit(
        :name, :email, :password, :password_confirmation, :phone, :voucher
      )

      if session[:indicator_id].present?
        to_return.merge!({
          indicator_id: session[:indicator_id]
        })
      end

      to_return
    end
end
