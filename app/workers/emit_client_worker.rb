class EmitClientWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options :queue => :default, :retry => 7

  sidekiq_retry_in do |count|
    (10 * count) + 2
  end

  def perform *params
    ec = EmitClient.new(*params)
    ec.send_to_bg_job_on_error = false
    ec.emit
  end
end
