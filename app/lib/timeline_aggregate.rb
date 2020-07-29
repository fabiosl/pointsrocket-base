class TimelineAggregate
  include ActionView::Helpers
  include Rails.application.routes.url_helpers

  attr_accessor :items

  def initialize
    @items = []
  end

  def check_if_item_is_part_of_group? item
    @items.map do |i|
      i.timelineable.created_at.beginning_of_day
    end.include? item.created_at.beginning_of_day
  end

  def created_at
    @items.map do |i|
      i.timelineable.created_at
    end.max
  end

  def timelineable
    self
  end

  def updated_at
    @items.map do |i|
      i.timelineable.updated_at
    end.max
  end

  def timelineable_type
    self.class.name
  end

  def pinned
    false
  end

  def subtitle
    users = @items.select do |timeline_item|
      begin
        timeline_item.timelineable.user.present?
      rescue Exception => e
        false
      end
    end.map do |timeline_item|
      timeline_item.timelineable.user
    end.uniq

    case users.size
    when 0
      I18n.t "api.#{api_key}.title.zero", item_title: item_title_with_url
    when 1
      person_1 = link_to(users[0].name, user_path(users[0]))
      I18n.t "api.#{api_key}.title.one", person: person_1, item_title: item_title_with_url
    else
      person_1 = link_to(users[0].name, user_path(users[0]))
      person_2 = link_to(users[1].name, user_path(users[1]))
      I18n.t "api.#{api_key}.title.other", person1: person_1, person2: person_2, count: users.size - 2, item_title: item_title_with_url
    end
  end

  def api_key
    self.class.name.underscore
  end

  def item_title_with_url
    link_to item_title, url
  end

  def item_title
    raise "ImplementMe"
  end

  def image
    raise "ImplementMe"
  end

  def comments
    raise "ImplementMe"
  end
end
