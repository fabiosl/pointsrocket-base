module DashboardHelper

  def distance_of_time_in_words_to_weekday(weekday)
    expiring_day = DateTime.parse(weekday)

    if expiring_day <= get_now_datetime
      expiring_day += 7.days
    end

    delta = expiring_day.mjd - get_now_datetime.mjd

    I18n.t('datetime.distance_in_words.weekday.in_x_days', count: delta)
  end

  def distance_of_time_in_words_to_praise_expiry_day
    distance_of_time_in_words_to_weekday(ENV['PRAISE_EXPIRITY_DATETIME'] || "Monday 07:00 BRST")
  end

  def get_now_datetime
    Time.now.to_datetime
  end

  def interaction_ico interaction
    case interaction.to_s
    when "comment"
      "comment"
    when "comments"
      "comment"
    when "love"
      "heart"
    when "like"
      "thumbs-up22"
    when "likes"
      "heart"
    when "haha"
      "happy"
    when "wow"
      "shocked"
    when "sorry"
      "sad"
    when "anger"
      "angry"
    when "shares"
      "share-alt"
    when "favorites"
      "star"
    when "views"
      "eye-open"
    when "dislikes"
      "thumbs-down"
    when "clicks"
      "cursor2"
    when "click"
      "cursor2"
    else
      interaction
    end
  end

end
