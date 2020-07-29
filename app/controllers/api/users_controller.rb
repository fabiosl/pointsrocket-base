module Api
  class UsersController < Api::BaseController
    before_filter :authenticate_user!
    skip_before_filter :authenticate_user!, only: :authenticate
    skip_before_action :verify_authenticity_token

    def me
      @user = current_user.decorate
      render :show
    end

    def update_me
      @user = current_user.decorate
      update
    end

    def authenticate
      if not params["email"].present? and not params["password"].present?
        render json: {
          message: "You must pass e-mail and password"
        }, status: :unprocessable_entity
        return
      end

      user = User.find_by email: params["email"]
      if not user
        render json: {
          message: "User not found for e-mail #{params["email"]}"
        }, status: :unprocessable_entity
        return
      end

      if user.valid_password?(params["password"])
        render json: {
          token: get_user_token(user)
        }
        return
      else
        render json: {
          message: "Bad credentials"
        }, status: :unprocessable_entity
        return
      end
    end

    def get_user_token user
      JWT.encode(
        {
          sub: user.id,
          iat: Time.now.to_i
        },
        Rails.application.secrets.secret_key_base,
        "HS256"
      )
    end


  private

    def user_params
      params.require(:user).permit(:email, :name, :avatar)
    end

  end
end
