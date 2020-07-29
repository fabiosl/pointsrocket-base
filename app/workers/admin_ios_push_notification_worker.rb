class AdminIosPushNotificationWorker < AdminPushNotificationWorker
  def run_notification
    anp = AppleNotificationPublisher.new

    if @domain.apn_key.file.present?
      anp.pem = @domain.apn_key.file.path
    else
      anp.pem = Rails.root.join("config/apn.pem")
    end

    anp.message = notification_title
    anp.device_token = @device.push_notification_token

    url = get_url_checking_cache

    if url.present?
      anp.other = {
        url: url
      }
    end

    if @unread_notifications_count > 0
      anp.badge = @unread_notifications_count
    end

    anp.sound = "default"
    anp.publish
  end
end
