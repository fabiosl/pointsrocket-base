module Api
  class NotificationsController < Api::BaseController
    include NotificationsHelper

    before_filter :authenticate_user!
    skip_before_action :verify_authenticity_token

    def index
      # @notifications = resource_class.for_user(current_user)
      @notifications = current_user.notifications

      if params["paging_key"].present?
        @notifications = @notifications.where("id < ?", params["paging_key"])
      end

      @notifications = @notifications.order("created_at desc").limit(10)
      @last_notification = @notifications.last
      set_response_headers
    end

    def create
      authorize! :manage_notifications, current_user
      super
      @notification.emit = true
      @notification.save

      # NotificationEmitClient.new("new", @notification)
    end

    def update
      authorize! :manage_notifications, current_user
      super
    end

    def destroy
      authorize! :manage_notifications, current_user
      super
    end

    def mark_all_as_read
      if params['ids'].present?
        @notifications = Notification.where(id: params['ids']).unread
        @notifications.update_all(read_at: Time.zone.now)
        # Notification.where(id: params['ids']).each do |notification|
        #   notification.notification_users.where(user: current_user).first_or_create do |nu|
        #     nu.is_read = true
        #   end
        # end
      end
      render nothing: true, status: :ok
    end

    private

    def get_hast_next_item
      if @last_notification
        resource_class.where(
            "id < ?", @last_notification.id.to_s
          ).order("created_at desc").any?
      else
        false
      end
    end

    def set_response_headers
      if @last_notification
        # setting has next interactions
        response.headers['HAS-NEXT-ITEM'] = get_hast_next_item().to_s

        # setting paging key
        response.headers['PAGGING_KEY'] = @last_notification.id.to_s
      end
    end

    def notification_params
      the_params = params.require(:notification).permit(
        :id,
        :title,
        :content,
        :notification_type,
        :notificable_id,
        :notificable_type,
        :user_id,
        :creator_id,
      )

      the_params
    end
  end
end
