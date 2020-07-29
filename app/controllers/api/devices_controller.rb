module Api
  class DevicesController < Api::BaseController
    include DevicesHelper

    before_filter :authenticate_user_from_token!
    before_filter :authenticate_user!
    skip_before_action :verify_authenticity_token

    def create_or_update
      if @device = current_user.devices.find_by(device_id: device_params[:device_id])
        if get_resource.update(resource_params.merge(id: @device.id))
          render :show
        else
          render json: get_resource_errors, status: :unprocessable_entity
        end
      else
        set_resource(resource_class.new(resource_params.merge(user: current_user)))
        if get_resource.save
          render :show, status: :created
        else
          render json: get_resource.errors, status: :unprocessable_entity
        end
      end
    end

    private

    def device_params
      params.require(:device).permit(
        :id,
        :name,
        :device_type,
        :device_id,
        :push_notification_token,
        :push_notification_active
      )
    end

    def authenticate_user_from_token!
      if params[:user_token].present?
        user = User.find_by(token_login: params[:user_token])

        if user
          sign_in user, store: false
        end
      end
    end

    def query_params
      params.permit(:email)
    end
  end
end
