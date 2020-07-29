class InvitesController < ApplicationController

  def token
    @invite = Invite.find_by token: params[:token], status: :pending
    if @invite.nil?
      flash[:info] = I18n.t('controllers.invites.token.invalid_token')
      redirect_to root_path
    else
      flash[:info] = I18n.t('controllers.invites.token.register_your_account')
      session[:invite_id] = @invite.id
      redirect_to new_user_registration_path
    end
  end

end
