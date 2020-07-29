class ChallengeUserApprovedMailWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options queue: :default, retry: true, backtrace: true

  def perform(domain_id, user_id, challenge_user_id)
    domain = Domain.find(domain_id)

    Apartment::Tenant.switch(domain.subdomain) do
      user = User.find(user_id)
      challenge_user = ChallengeUser.find(challenge_user_id)

      ChallengeUserMailer.challenge_user_approved_email(
        domain, user, challenge_user
      ).deliver if user.subscribe
    end
  end
end
