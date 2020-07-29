class CrawlersCronWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options :queue => :default

  def perform
    if_queue_is_down do
      Apartment.tenant_names.each do |tenant|
        if tenant.present?
          [:youtube, :facebook, :instagram].each do |social_network|
            Apartment::Tenant.switch(tenant) do
              User.read_to_crawl(social_network).pluck("id").each do |id|
                p "calling #{tenant} #{id} #{social_network}"
                CrawlerCallerWorker.perform_async tenant, id, social_network
              end
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
