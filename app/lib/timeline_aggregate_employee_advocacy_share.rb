class TimelineAggregateEmployeeAdvocacyShare < TimelineAggregate

  def check_if_item_is_part_of_group? item
    # super(item) and
    @items.first.timelineable.employee_advocacy_post == item.timelineable.employee_advocacy_post
  end

  def item_title
    @items.first.timelineable.employee_advocacy_post.title
  end

  def image
    @items.first.timelineable.employee_advocacy_post.image.url(:thumb)
  end

  def url
    employee_advocacy_path
  end

  def comments
    []
  end
end
