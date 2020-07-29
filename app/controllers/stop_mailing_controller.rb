class StopMailingController < ApplicationController
  layout "stop_mailing"
  before_action :load_user_by_token

  class TokenInvalid < Exception ; end

  def index
  end

  def destroy
    @user.subscribe = false
    @user.save
    render :index
  end

  def load_user_by_token
    begin
      user_id = Rails.application.message_verifier(:unsubscribe).verify(params[:token])
      @user = User.find user_id
    rescue ActiveSupport::MessageVerifier::InvalidSignature, ActiveRecord::RecordNotFound => e
      flash[:alert] = I18n.t('controllers.application.forbidden_action')
      redirect_to root_path
    rescue Exception => e
      Rails.logger.info "not handled exception #{e.message} #{e.backtrace}"
      flash[:alert] = I18n.t('controllers.application.forbidden_action')
      redirect_to root_path
    end
  end
end
