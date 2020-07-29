class HashtagChallengeUserDecorator < Draper::Decorator
  delegate_all

  class NoAuthorFollowersPresent < Exception ; end
  class JsonEmptyExeption < Exception ; end

  GOOD_INTERACTIONS = [
    'comment', 'comments', 'love', 'like', 'likes', 'haha', 'wow',
    'shares', 'favorites', 'star', 'views'
  ]

  BAD_INTERACTIONS = [
    'sorry', 'anger', 'dislikes'
  ]

  def get_cost
    if not object.json.present?
      return 0
    end
    the_json = JSON.parse object.json

    the_json["_source"]["cost"] || 0
  end

  def get_post_id
    if not object.json.present?
      return ""
    end
    the_json = JSON.parse object.json

    the_json["_source"]["id"]
  end

  def get_post_author_id
    if not object.json.present?
      return ""
    end
    the_json = JSON.parse object.json

    the_json["_source"]["author"]["id"]
  end

  def get_post_social_network
    if not object.json.present?
      return ""
    end
    the_json = JSON.parse object.json

    the_json["_source"]["social_network"]
  end

  def get_post_social_network_icon
    network = get_post_social_network
    return "" if not network.present?
    network
  end

  def get_post_url
    object.url
  end

  def post_external_url
    return '' unless object.json.present?
    parsed_json = JSON.parse(object.json)

    parsed_json["_source"]["link"]
  end

  def has_post_picture?
    get_post_picture.present?
  end

  def get_post_picture
    if not object.json.present?
      return ""
    end
    the_json = JSON.parse object.json

    the_json["_source"]["picture"]
  end

  def get_post_message
    if not object.json.present?
      return ""
    end
    the_json = JSON.parse object.json

    the_json["_source"]["message"]
  end

  def get_metrics
    if not object.json.present?
      return []
    end
    the_json = JSON.parse object.json
    the_json["_source"]["metrics"] || []
  end

  def interaction_count
    get_metrics.inject({good: 0, bad: 0, total: 0}) do |memo, metric|
      memo[:total] += metric['value']

      if GOOD_INTERACTIONS.include? metric['name']
        memo[:good] += metric['value']
      else
        memo[:bad] += metric['value']
      end

      memo
    end
  end

  def get_json
    if not object.json.present?
      raise JsonEmptyExeption.new("Json is empty")
    end

    JSON.parse object.json
  end

  def author_followers
    the_json = get_json

    if the_json["_source"]["author"]["followers_count"].nil?
      raise NoAuthorFollowersPresent.new("followers count is now #{the_json}")
    else
      the_json["_source"]["author"]["followers_count"]
    end
  end

  def author_id
    the_json = get_json
    the_json["_source"]["author"]["id"]
  end

  def get_metric_icon metric, social_network
    case metric
    when "comment"
      return "comment"
    when "comments"
      return "comment"
    when "love"
      return "heart"
    when "like"
      return "thumbs-up22"
    when "likes"
      return "heart"
    when "haha"
      return "happy"
    when "wow"
      return "shocked"
    when "sorry"
      return "sad"
    when "anger"
      return "angry"
    when "shares"
      return "share-alt"
    when "favorites"
      return "star"
    when "views"
      return "eye-open"
    when "dislikes"
      return "thumbs-down"
    else
      return metric
    end
  end

  def post_created_at
    if not object.json.present?
      if object.respond_to? :created_at
        return object.created_at
      end
      raise "NoJsonOrCreatedAt"
    end
    the_json = JSON.parse object.json

    DateTime.parse("#{the_json["_source"]["created_time"]} UTC").to_datetime.in_time_zone Time.zone
  end

  def formatted_social_datetime format=:short
    I18n.l post_created_at, format: format
  end
end
