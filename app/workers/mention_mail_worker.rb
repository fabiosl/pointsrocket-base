class MentionMailWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options queue: :default, retry: 5, backtrace: true

  def perform(domain_id, user_id, mentionable_class, mentionable_id)
    domain = Domain.find(domain_id)

    Apartment::Tenant.switch(domain.subdomain) do
      user = User.find(user_id)
      mentionable = mentionable_class.constantize.find(mentionable_id)

      MentionMailer.new_mention_email(domain, user, mentionable).deliver if user.subscribe
    end
  end
end
