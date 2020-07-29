class EmployeeAdvocacyShareDecorator < Draper::Decorator
  delegate_all

  REACTIONS = [
    :like,
    :wow,
    :sad,
    :love,
    :haha,
    :angry,
    :thankful,
    :pride
  ]

  TWITTER_INTERACTIONS = [
    :shares,
    :favorites
  ]

  VISIBLE_INTERACTIONS = REACTIONS + [:clicks] + TWITTER_INTERACTIONS

  GOOD_REACTIONS = [
    :like,
    :wow,
    :love,
    :haha,
    :thankful,
    :pride
  ]

  BAD_REACTIONS = [
    :sad,
    :angry,
  ]

  class URLNotFound < Exception ; end
  class TitleNotFound < Exception ; end
  class ImageNotFound < Exception ; end

  def post_title
    if object.post_json.present? and object.post_json["title"].present?
      object.post_json["title"]
    elsif object.employee_advocacy_post.present?
      object.employee_advocacy_post.title
    else
      raise TitleNotFound.new("No title found in share #{object.id} #{object.to_json}")
    end
  end

  def redirect_url
    if object.post_json.present? and object.post_json["url"].present?
      url = object.post_json["url"]
    elsif object.employee_advocacy_post.present?
      url = object.employee_advocacy_post.url
    else
      raise URLNotFound.new("No url found in share #{object.id} #{object.to_json}")
    end

    if not url.starts_with? "http://" and not url.starts_with? "https://"
      url = "http://#{url}"
    end
    url
  end

  def image_url
    if object.post_json.present? and object.post_json["image"]["thumb"].present?
      image = object.post_json["image"]["thumb"]["url"]
    else
      raise ImageNotFound.new("No image found n share #{object.id} #{object.to_json}")
    end
  end

  def real_shares_count
    return 0 unless object.social_json
    JSON.parse(object.social_json).size
  end

  def get_reactions
    return unless object.social_json

    parsed_social_json = JSON.parse(object.social_json)
    parsed_social_json.inject({}) do |memo, social_json_item|
      if social_json_item["json"].present?
        REACTIONS.each do |r|
          count = social_json_item["json"][r.upcase.to_s]["summary"]["total_count"]
          if not count.nil?
            memo[r] ||= 0
            memo[r] += count
          end
        end
      end
      memo
    end
  end

  def get_twitter_interactions
    return unless object.social_json

    parsed_social_json = JSON.parse(object.social_json)
    parsed_social_json.inject({}) do |memo, social_json_item|
      if social_json_item["json"].present?
        memo[:shares] ||= 0
        memo[:favorites] ||= 0

        memo[:shares] += social_json_item["json"]["retweet_count"]
        memo[:favorites] += social_json_item["json"]["favorite_count"]
      end
      memo
    end
  end

  def interaction_count
    clicks = employee_advocacy_visits.count

    to_return = {
      total: clicks,
      clicks: clicks,
      good: 0,
      bad: 0
    }

    if social_network.to_sym == :facebook
      reactions = get_reactions || {}

      good = GOOD_REACTIONS.inject(0) do |memo, r|
        memo + (reactions[r.downcase.to_sym] || 0)
      end

      good += clicks

      bad = BAD_REACTIONS.inject(0) do |memo, r|
        memo + (reactions[r.downcase.to_sym] || 0)
      end

      to_return[:good] += good
      to_return[:bad] += bad
      to_return.merge!(reactions)
    elsif social_network.to_sym == :twitter
      twitter_interactions = get_twitter_interactions
      # twitter we don`t have bad interaction
      twitter_interactions.each do |k, v|
        to_return[:good] += v
      end

      to_return.merge!(twitter_interactions)
    end

    to_return
  end

  def get_cost
    case social_network
    when "facebook"
      employee_advocacy_visits.count * 0.58
    when "twitter"
      employee_advocacy_visits.count * 0.72
    when "linkedin"
      employee_advocacy_visits.count * 3.7
    else
      0
    end
  end

  def formatted_created_at
    object.created_at.strftime("%d/%m/%y #{I18n.t('views.general.time_at')} %H:%M")
  end

  def external_url
    return unless object.social_json

    parsed_social_json = JSON.parse(object.social_json)
    element_id = parsed_social_json[0]['id']

    case object.social_network
    when 'twitter'
      "https://twitter.com/statuses/#{element_id}"
    when 'facebook'
      "https://facebook.com/#{element_id}"
    when 'linkedin'
      parsed_social_json[0]['updateUrl']
    when 'instagram'
      "https://instagram.com"
    end
  end
end
