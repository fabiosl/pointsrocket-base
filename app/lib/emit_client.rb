class EmitClient

  attr_accessor :send_to_bg_job_on_error

  def initialize event, user_id, data
    @event = event
    @user_id = user_id
    @data = data
    @send_to_bg_job_on_error = true
  end

  def emit
    url = ENV['SOCKET_URL']

    headers = {
      "Content-Type" => "application/json",
    }

    payload = {
      event: @event,
      user_id: @user_id,
      tenant: Apartment::Tenant.current,
      data: @data,
    }

    begin
      HTTParty.post(
        url,
        headers: headers,
        body: payload.to_json,
      )
    rescue Exception => e
      ap e
      if @send_to_bg_job_on_error
        send_to_bg_job_on_error!
      else
        raise e
      end
    end
  end

  def send_to_bg_job_on_error!
    p "sending to backgroud job"
    EmitClientWorker.perform_async(@event, @user_id, @data)
  end
end
