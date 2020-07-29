module Api
  class BaseController < ApplicationController
    class TokenValidButUserNotFound < Exception ; end
    before_action :authenticate_user_with_token
    protect_from_forgery with: :null_session
    before_action :set_resource, only: [:destroy, :show, :update]
    respond_to :json
    before_action :default_format_json

    rescue_from CanCan::AccessDenied do |exception|
      render json: {
          message: exception.message
        }, status: :unauthorized
    end

    def default_format_json
      if params[:format].nil?
        request.format = "json"
      end
    end

    def must_notify?
      true
    end

    def authenticate_user_with_token
      token = params["token"]

      if token.present?
        begin
          data, options = JWT.decode(
            token,
            Rails.application.secrets.secret_key_base,
            true,
            {
              algorithm:
              "HS256"
            }
          )

          user = User.find data["sub"]

          if not user
            raise TokenValidButUserNotFound.new("token generated #{data.to_json}, but user isn`t found.")
          end

          sign_in user, store: false
        rescue JWT::VerificationError, TokenValidButUserNotFound, JWT::DecodeError => e
          ap e.message
        end
      end
    end

    # POST /api/{plural_resource_name}
    def create
      new_resource_with_params
      if get_resource.save
        notify_users(get_resource, 'create') if must_notify?
        render :show, status: :created
      else
        render json: get_resource.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/{plural_resource_name}/1
    def destroy
      get_resource.destroy
      head :no_content
    end

    # GET /api/{plural_resource_name}
    def index
      plural_resource_name = "@#{resource_name.pluralize}"
      resources = resource_class.where(query_params)
                                .order(default_order)
                                .paginate(
                                  page: page_params[:page],
                                  per_page: page_params[:page_size]
                                )

      instance_variable_set(plural_resource_name, resources)
      respond_with instance_variable_get(plural_resource_name)
    end

    # GET /api/{plural_resource_name}/1
    def show
      respond_with get_resource
    end

    def after_update_success
      render :show
    end

    # PATCH/PUT /api/{plural_resource_name}/1
    def update
      if get_resource.update(resource_params)
        after_update_success
      else
        render json: get_resource_errors, status: :unprocessable_entity
      end
    end

    private

      def new_resource_with_params
        set_resource(resource_class.new(resource_params))
      end

      def default_order
        'id desc'
      end

      def get_resource_errors
        get_resource.errors
      end

      # Returns the resource from the created instance variable
      # @return [Object]
      def get_resource
        instance_variable_get("@#{resource_name}")
      end

      # Returns the allowed parameters for searching
      # Override this method in each API controller
      # to permit additional parameters to search on
      # @return [Hash]
      def query_params
        {}
      end

      # Returns the allowed parameters for pagination
      # @return [Hash]
      def page_params
        params.permit(:page, :page_size)
      end

      # The resource class based on the controller
      # @return [Class]
      def resource_class
        @resource_class ||= resource_name.classify.constantize
      end

      # The singular name for the resource class based on the controller
      # @return [String]
      def resource_name
        @resource_name ||= self.controller_name.singularize
      end

      # Only allow a trusted parameter "white list" through.
      # If a single resource is loaded for #create or #update,
      # then the controller for the resource must implement
      # the method "#{resource_name}_params" to limit permitted
      # parameters for the individual model.
      def resource_params
        @resource_params ||= self.send("#{resource_name}_params")
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_resource(resource = nil)
        resource ||= resource_class.find(params[:id])
        instance_variable_set("@#{resource_name}", resource)
      end

      def notify_users(notifiable, action)
        User.exclude(current_user).each do |user|
          Notification.create!(
            recipient: user,
            actor: current_user,
            action: action,
            notifiable: notifiable
          )
        end
      end

      def is_admin_request?
        current_user.present? and current_user.admin == true and request.headers["ADMIN_REQUEST"] == 'true'
      end
  end
end
