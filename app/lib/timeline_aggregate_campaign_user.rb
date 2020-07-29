class TimelineAggregateCampaignUser < TimelineAggregate

  def check_if_item_is_part_of_group? item
    # super(item) and
    @items.first.timelineable.campaign == item.timelineable.campaign
  end

  def id
    @items.first.timelineable.campaign.id
  end

  def type
    @items.first.timelineable.campaign.class.name
  end

  def item_title
    @items.first.timelineable.campaign.title
  end

  def image
    @items.first.timelineable.campaign.image.url(:thumb)
  end

  def url
    campaigns_path
  end

  def comments
    @items.first.timelineable.campaign.comments
  end

  def api_key
    if @items.first.timelineable.campaign.redeem_points
      "timeline_aggregate_campaign_user_redeem"
    else
      super
    end
  end
end
