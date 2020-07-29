class AndroidPushNotificationWorker < PushNotificationWorker
  def run_notification
    api_key = @domain.get_android_api_key

    anp = AndroidNotificationPublisher.new
    anp.key = api_key
    anp.message = notification_title
    anp.devices_ids = [@device.push_notification_token]

    url = get_url_checking_cache

    if url.present?
      anp.data = {
        url: url
      }
    end

    anp.not_registereds_block = Proc.new {|tokens_not_registereds|
      Device.android.where(
        push_notification_token: tokens_not_registereds
      ).update_all(
        push_notification_active: false
      )
    }

    anp.publish
  end
end
