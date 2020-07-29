module SocialCredentials
  def facebook_app_id
    super || ENV['FACEBOOK_APP_ID']
  end

  def facebook_app_secret
    super || ENV['FACEBOOK_APP_SECRET']
  end

  def instagram_app_id
    super || ENV['INSTAGRAM_APP_ID']
  end

  def instagram_app_secret
    super || ENV['INSTAGRAM_APP_SECRET']
  end

  def youtube_app_id
    super || ENV['YOUTUBE_APP_ID']
  end

  def youtube_app_secret
    super || ENV['YOUTUBE_APP_SECRET']
  end
end