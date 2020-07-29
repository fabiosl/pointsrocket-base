class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_notification, only: [:read]

  def index
    @notifications = Notification.all_with_read(current_user).order(created_at: :desc)

    if current_user.new_notifications_count > 5
      limit = current_user.new_notifications_count
    else
      limit = 5
    end
    @notifications = @notifications.limit(limit)
  end

  def read_all
    Notification.mark_all_notifications_read_for(current_user)
    render nothing: true, status: :ok
  end

  def read
    @notification.mark_notification_read_for current_user
    render nothing: true, status: :ok
  end

  private

    def set_notification
      @notification = Notification.all_for_user(current_user).find(params[:id])
    end
end
