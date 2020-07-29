class MessageMailWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options queue: :default, retry: true, backtrace: true

  def perform(domain_id, user_id, message_id)
    domain = Domain.find(domain_id)

    Apartment::Tenant.switch(domain.subdomain) do
      user = User.find(user_id)
      message = Message.find(message_id)

      MessageMailer.new_message_email(domain, user, message).deliver if user.subscribe
    end
  end
end
