class TokensController < ApplicationController
  def index
    token = Token.get_by_key params[:key]

    if token
      set_previous_user_session(current_user)
      sign_in(:user, token.user)
      token.destroy

      redirect_to main_app.root_path, status: :found
    else
      render text: "User not found or token is invalid"
    end
  end

  def generate
    authorize! :generate_token, current_user
    
    token = Token.create_for email: params[:email]
    domain = Domain.find_by(subdomain: params[:subdomain])
 
    if token
      token_url = "#{domain.get_url}/token-login?key=#{token.key}"
      render json: { token: { url: token_url } }
    else
      render json: I18n.t('controllers.token.generate.error'),
             status: :not_found
    end
  end

  private

  def set_previous_user_session(user)
    session['previous_user_id'] = user.id if user
  end
end
