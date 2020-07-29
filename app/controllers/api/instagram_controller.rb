module Api
  class InstagramController < ApplicationController
    protect_from_forgery with: :null_session
    respond_to :json
    before_action :default_format_json
    before_filter :authenticate_user!
    skip_before_action :verify_authenticity_token

    def default_format_json
      if params[:format].nil?
        request.format = "json"
      end
    end

    def user

      begin
        client = Instagram.client access_token: current_user.get_instagram_access_token(@domain)
        render json: client.user

      rescue Exception => e
        if Rails.env.production?
          render json: {
            error: true,
            message: e.message
          }, status: :unprocessable_entity
          return
        else
          raise e
        end

      end
    end

  end
end
