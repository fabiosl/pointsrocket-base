class QuestionMailWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options queue: :default, retry: true, backtrace: true

  def perform(domain_id, user_id, question_id)
    domain = Domain.find(domain_id)

    Apartment::Tenant.switch(domain.subdomain) do
      user = User.find(user_id)
      question = Question.find(question_id)

      QuestionMailer.new_question_email(domain, user, question).deliver
    end
  end
end
