# esta em desuso por enquanto

class NotificationEmitClient < EmitClient

  def initialize event, notification
    event = event + "_notification"
    user_id = notification.user_id
    data = Rabl::Renderer.new(
      'api/notifications/show',
      Notification.first,
      {
        :view_path => 'app/views',
      }).render

    data = JSON.parse data

    super(event, user_id, data)
  end

end
