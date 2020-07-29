class AppleNotificationPublisher
  attr_accessor :pem, :device_token, :message, :badge, :sound, :other

  def publish
    APNS.host = ENV['APN_HOST'] || 'gateway.sandbox.push.apple.com'

    APNS.pem  = @pem

    options = {
      alert: @message
    }

    # 1
    if @badge.present?
      options[:badge] = @badge
    end

    # default
    if @sound.present?
      options[:sound] = @sound
    end

    if @other.present?
      options[:other] = @other
    end

    ap "sending notification with options #{options}"

    APNS.send_notification(@device_token, options)
  end
end
