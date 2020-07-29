class CommentMailWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options queue: :default, retry: true, backtrace: true

  def perform(domain_id, user_id, comment_id)
    domain = Domain.find(domain_id)

    Apartment::Tenant.switch(domain.subdomain) do
      user = User.find(user_id)
      comment = Comment.find(comment_id)
      # begin
      # rescue ActiveRecord::RecordNotFound => e
      #   ap "comment not found for id #{comment_id}"
      #   return
      # end

      CommentMailer.new_comment_email(domain, user, comment).deliver
    end
  end
end
