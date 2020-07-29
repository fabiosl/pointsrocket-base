class TimelineAggregateHashtagChallengeUser < TimelineAggregate

  def check_if_item_is_part_of_group? item
    # super(item) and
    @items.first.timelineable.hashtag_challenge == item.timelineable.hashtag_challenge
  end

  def id
    @items.first.timelineable.hashtag_challenge.id
  end

  def type
    @items.first.timelineable.hashtag_challenge.class.name
  end

  def item_title
    @items.first.timelineable.hashtag_challenge.title
  end

  def image
    @items.first.timelineable.hashtag_challenge.image.url(:thumb)
  end

  def url
    hashtag_challenge_path @items.first.timelineable.hashtag_challenge
  end

  def comments
    @items.first.timelineable.hashtag_challenge.comments
  end
end
