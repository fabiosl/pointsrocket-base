class AdvocacyCronWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options :queue => :default

  def perform
    if_queue_is_down do
      Apartment.tenant_names.select(&:present?).each do |tenant|
        Apartment::Tenant.switch(tenant) do
          if_current_domain_permit_advocacy_crawler? do
            [:facebook, :twitter].each do |social_network|
              User.read_to_crawl_advocacy(social_network).pluck("id").each do |id|
                p "calling #{tenant} #{id} #{social_network}"
                AdvocacyCrawler.perform_async tenant, id, social_network
              end
            end
          end
        end
      end
    end
  end

  def if_current_domain_permit_advocacy_crawler? &block
    if d = Domain.get_current_domain
      if d.employee_advocacy_enabled
        yield
      else
        ap "domain #{d.name} don`t have advocacy enabled"
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
