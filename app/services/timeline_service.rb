class TimelineService
  attr_reader :has_next

  def initialize user
    @user = user
    @page = 1
    @has_next = false
  end

  def set_page page
    @page = page
    self
  end

  def params(parameters)
    @params = (parameters || {}).with_indifferent_access
    self
  end

  # algoritm de criação de timeline
  def create_timeline
    items = TimelineItem.visible

    # Testing
    # items = TimelineItem.visible.where(timelineable_type: "CampaignUser")

    if @params[:timelineable_type] && @params[:timelineable_id]
      ids_from_params = items.where(
        timelineable_type: @params[:timelineable_type],
        timelineable_id: @params[:timelineable_id]
      ).pluck('id')

      items_from_params = TimelineItem.where(id: ids_from_params)
    else
      ids_from_params = []
      items_from_params = []
    end

    @items = items.visible
                .where.not(id: ids_from_params)
                .default
                .order('pinned desc, created_at desc')
                .limit(100)
                .to_a
                .select {|i|
                  if i.timelineable_type == "CampaignUser" && i.timelineable.campaign.is_redeemable?
                    false
                  elsif i.timelineable_type == "CampaignUser" && i.timelineable.user.admin
                    false
                  else
                    true
                  end
                }

    @items = items_from_params + @items

    blocked_user_ids = @user.block_users.pluck("blocked_id")

    @items = @items.select do |timeline_item|
      timelineable = timeline_item.timelineable
      if timelineable.present? and timelineable.respond_to? :user_id
        not blocked_user_ids.include? timelineable.user_id
      else
        true
      end
    end

    @items = @items.inject([]) do |memo, timeline_item|
      begin
        class_name = "TimelineAggregate#{timeline_item.timelineable_type}"
        klass = class_name.constantize
      rescue Exception => e
        class_name = nil
        klass = nil
      end

      if not klass.nil?
        timeline_aggregate_item = memo.find do |i|
          i.class.name == class_name and
            i.check_if_item_is_part_of_group? timeline_item
        end

        if timeline_aggregate_item.present?
          timeline_aggregate_item.items << timeline_item
        else
          timeline_aggregate_item = klass.new
          timeline_aggregate_item.items << timeline_item
          memo << timeline_aggregate_item
        end
      else
        memo << timeline_item
      end

      memo
    end

  end

  def get_timeline_items
    create_timeline

    @has_next = @items.select.each_slice(10).to_a.size > @page
    @items.select.each_slice(10).to_a[@page - 1]
  end
end
