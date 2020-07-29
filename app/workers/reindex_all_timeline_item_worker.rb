class ReindexAllTimelineItemWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options :queue => :default, :retry => true, backtrace: true

  def perform user_id
    tenants = Apartment.tenant_names + ["public"]

    tenants.each do |tenant|
      if tenant.present?
        Apartment::Tenant.switch(tenant) do
          TimelineItem.all.each do |timeline_item|
            if timeline_item.timelineable.respond_to?(:user_id)
              if timeline_item.timelineable.user_id.to_i == user_id.to_i
                ap "reindexing #{timeline_item.id}"
                timeline_item.send_to_index
              end
            end
          end
        end
      end
    end
  end

end
