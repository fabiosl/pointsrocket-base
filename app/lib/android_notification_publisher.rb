class AndroidNotificationPublisher
  attr_accessor :key, :message, :devices_ids, :not_registereds_block, :data, :icon

  def publish
    fcm = FCM.new(@key)

    options = {
      notification: {
        body: @message
      }
    }

    options[:notification][:icon] = @icon || "notification_icon"
    options[:icon] = @icon || "notification_icon"

    if @data.present?
      options[:data] = @data
    end

    ap "sending notification with options #{options}"

    response = fcm.send(@devices_ids, options)

    if response[:not_registered_ids].present? and @not_registereds_block.present?
      @not_registereds_block.call response[:not_registered_ids]
    end

    response
  end
end
