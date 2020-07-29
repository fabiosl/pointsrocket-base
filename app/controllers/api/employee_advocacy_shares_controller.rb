module Api
  class EmployeeAdvocacySharesController < Api::BaseController
    include TriggerEventsHelper
    before_action :set_employee_advocacy_post, only: [:shares_to_post]
    before_filter :authenticate_user!
    skip_before_action :verify_authenticity_token
    load_and_authorize_resource

    def index
      @employee_advocacy_shares = current_user.employee_advocacy_shares
    end

    def shares_to_post
      @employee_advocacy_shares = @employee_advocacy_post.employee_advocacy_shares
      render :index
    end

    def get_link
      if domain = Domain.get_current_domain
        if domain.advocacy_posts_limit_by_day > 0
          shared_today = current_user.employee_advocacy_shares.where({
            created_at: (Time.now.beginning_of_day..Time.now)
          }).count

          if shared_today >= domain.advocacy_posts_limit_by_day
            render json: {error: 'limit_reached', limit: domain.advocacy_posts_limit_by_day}, status: :unprocessable_entity
            return
          end
        end
      end

      if @employee_advocacy_share = current_user.employee_advocacy_shares.where({
        social_network: employee_advocacy_share_params[:social_network],
        employee_advocacy_post_id: employee_advocacy_share_params[:employee_advocacy_post_id],
        }).first
        @first_share = false
      else
        @first_share = true
        set_resource(resource_class.new(resource_params))
      end

      get_resource.save

      link = EmployeeAdvocacy::SharePublisher.get_short_link @employee_advocacy_share, base_url: request.base_url

      render json: {link: link, id: get_resource.id, first_share: @first_share}
    end

    def delete_share
      if @employee_advocacy_share = current_user.employee_advocacy_shares.where(id: params[:id]).first
        @employee_advocacy_share.destroy
        render json: {ok: 'ok'}
      end
    end

    def create_share
      if @employee_advocacy_share = current_user.employee_advocacy_shares.where({
        social_network: employee_advocacy_share_params[:social_network],
        employee_advocacy_post_id: employee_advocacy_share_params[:employee_advocacy_post_id],
        }).first
        @first_share = false
        @employee_advocacy_share.user_content = employee_advocacy_share_params[:user_content]
        @employee_advocacy_share.where_to_publish = employee_advocacy_share_params[:where_to_publish]
        @employee_advocacy_share.save
      else
        @first_share = true
        set_resource(resource_class.new(resource_params))
      end

      get_resource.save

      @badges_added = []

      @points_added = false
      if get_resource.persisted?
        begin
          trigger_events = []
          trigger_events << TriggerEvent.new.run("employee_advocacy_share_created", Apartment::Tenant.current, get_resource)
          trigger_events << TriggerEvent.new.run("employee_advocacy_share_#{get_resource.social_network}_created", Apartment::Tenant.current, get_resource)

          @badges_added = get_badges_added_from_trigger_events trigger_events
          Rails.logger.info "@badges_added"
          Rails.logger.info @badges_added

          points_addeder = EmployeeAdvocacy::Points.new(get_resource)
          points_addeder.add_points!
          @employee_advocacy_share.points_added = points_addeder.points_added

          render :show, status: :created
        rescue Exception => e
          ap e.message
          ap e.backtrace
          if @first_share
            get_resource.destroy
          end
          render json: {message: e.message}, status: 500
        end
      else
        render json: get_resource.errors, status: :unprocessable_entity
      end
    end

    def create
      # check if has shared today
      if domain = Domain.get_current_domain
        if domain.advocacy_posts_limit_by_day > 0
          shared_today = current_user.employee_advocacy_shares.where({
            created_at: (Time.now.beginning_of_day..Time.now)
          }).count

          if shared_today >= domain.advocacy_posts_limit_by_day
            render json: {error: 'limit_reached', limit: domain.advocacy_posts_limit_by_day}, status: :unprocessable_entity
            return
          end
        end
      end

      if @employee_advocacy_share = current_user.employee_advocacy_shares.where({
          social_network: employee_advocacy_share_params[:social_network],
          employee_advocacy_post_id: employee_advocacy_share_params[:employee_advocacy_post_id],
        }).first
        @first_share = false
        @employee_advocacy_share.user_content = employee_advocacy_share_params[:user_content]
        @employee_advocacy_share.where_to_publish = employee_advocacy_share_params[:where_to_publish]
        @employee_advocacy_share.save
      else
        @first_share = true
        set_resource(resource_class.new(resource_params))
      end

      get_resource.save

      @badges_added = []

      @points_added = false
      if get_resource.persisted?
        begin
          EmployeeAdvocacy::SharePublisher.publish(get_resource, base_url: request.base_url)
          trigger_events = []
          trigger_events << TriggerEvent.new.run("employee_advocacy_share_created", Apartment::Tenant.current, get_resource)
          trigger_events << TriggerEvent.new.run("employee_advocacy_share_#{get_resource.social_network}_created", Apartment::Tenant.current, get_resource)

          @badges_added = get_badges_added_from_trigger_events trigger_events
          Rails.logger.info "@badges_added"
          Rails.logger.info @badges_added

          points_addeder = EmployeeAdvocacy::Points.new(get_resource)
          points_addeder.add_points!
          @employee_advocacy_share.points_added = points_addeder.points_added

          render :show, status: :created
        rescue Exception => e
          ap e.message
          ap e.backtrace
          if @first_share
            get_resource.destroy
          end
          render json: {message: e.message}, status: 500
        end
      else
        render json: get_resource.errors, status: :unprocessable_entity
      end
    end

    private

      def set_employee_advocacy_post
        @employee_advocacy_post = EmployeeAdvocacyPost.find params[:employee_advocacy_post_id]
      end

      def employee_advocacy_share_params
        the_params = params.require(:employee_advocacy_share).permit(
          :id,
          :employee_advocacy_post_id,
          :social_network,
          :user_content,
          :where_to_publish,
        )

        the_params.merge!(user_id: current_user.id)

        the_params
      end

      def notify_users(resource, action)
        nil
      end
  end
end
