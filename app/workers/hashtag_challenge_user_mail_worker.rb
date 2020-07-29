class HashtagChallengeUserMailWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options queue: :default, retry: true, backtrace: true

  def perform(domain_id, user_id, hashtag_challenge_user_id)
    domain = Domain.find(domain_id)

    Apartment::Tenant.switch(domain.subdomain) do
      user = User.find(user_id)
      hashtag_challenge_user = HashtagChallengeUser.find(hashtag_challenge_user_id)

      HashtagChallengeUserMailer.new_hashtag_challenge_user_email(
        domain, user, hashtag_challenge_user
      ).deliver
    end
  end
end
