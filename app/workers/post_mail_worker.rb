class PostMailWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options :queue => :default, :retry => true, backtrace: true

  def perform(domain_id, user_id, post_id)
    domain = Domain.find(domain_id)

    Apartment::Tenant.switch(domain.subdomain) do
      user = User.find(user_id)
      post = Post.find(post_id)

      PostMailer.new_post_email(domain, user, post).deliver if user.subscribe
    end
  end
end
