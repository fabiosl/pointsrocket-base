module Api
  class UserHasGetToken < Exception ; end
  class TokenMissing < Exception ; end

  class TokensController < Api::BaseController
    before_filter :authenticate_user!, only: :get_current_user_token
    skip_before_action :authenticate_user_with_token

    def get_current_user_token
      current_user.generate_token_login!
      render text: current_user.token_login
    end

    def token_login
      begin
        token = params[:token]
        raise TokenMissing.new("token param not passed") if not token.present?
        user = User.find_by token_login: token
        raise ActiveRecord::RecordNotFound.new("No user found for token #{token}") if not user.present?
        sign_in(:user, user)

        if params[:ref].present?
          redirect_to params[:ref]
        else
          redirect_to root_path
        end

      rescue Exception => e
        flash[:alert] = e.message
        redirect_to new_user_session_path(no_token: true)
      end

    end
  end
end
