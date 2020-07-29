class TimelineAggregateChallengeUser < TimelineAggregate

  def check_if_item_is_part_of_group? item
    # super(item) and
    @items.first.timelineable.challenge == item.timelineable.challenge
  end

  def id
    @items.first.timelineable.challenge.id
  end

  def type
    @items.first.timelineable.challenge.class.name
  end

  def item_title
    @items.first.timelineable.challenge.title
  end

  def image
    @items.first.timelineable.challenge.image.url(:thumb)
  end

  def url
    challenge_path @items.first.timelineable.challenge
  end

  def comments
    @items.first.timelineable.challenge.comments
  end
end
