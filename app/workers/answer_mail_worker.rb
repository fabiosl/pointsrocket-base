class AnswerMailWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options queue: :default, retry: true, backtrace: true

  def perform(domain_id, user_id, answer_id)
    domain = Domain.find(domain_id)

    Apartment::Tenant.switch(domain.subdomain) do
      user = User.find(user_id)
      answer = Answer.find(answer_id)

      AnswerMailer.new_answer_email(domain, user, answer).deliver
    end
  end
end
