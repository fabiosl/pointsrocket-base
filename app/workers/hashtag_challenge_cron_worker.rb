class HashtagChallengeCronWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options :queue => :default, :retry => true, backtrace: true

  def perform
    if_queue_is_down do
      tenants = Apartment.tenant_names

      tenants.each do |tenant|
        if tenant.present?
          Apartment::Tenant.switch(tenant) do
            HashtagChallenge.pluck("id").each do |id|
              HashtagChallengeSocialWorker.perform_async id, tenant
            end
          end
        end
      end
    end
  end

  def if_queue_is_down &block
    if Sidekiq::Queue.new('default').size <= 10
      yield
    else
      ap "Queue default is high #{Sidekiq::Queue.new('default').size}"
    end
  end

end
