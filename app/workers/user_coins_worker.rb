class UserCoinsWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options queue: :default, retry: true, backtrace: true

  def perform
    Apartment.tenant_names.select(&:present?).each do |tenant|
      domain = Domain.find_by(subdomain: tenant)
      reset_domain_users_points(domain)
    end
  end

  private

  def reset_domain_users_points(domain)
    return unless domain.peer_recognition_enabled?
    Apartment::Tenant.switch(domain.subdomain) do
      User.all.each do |user|
        ResetUserCoinsWorker.perform_async(domain.subdomain, user.id)
      end
    end
  end
end
