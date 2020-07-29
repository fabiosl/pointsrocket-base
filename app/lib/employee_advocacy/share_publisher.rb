class EmployeeAdvocacy::SharePublisher

  def self.publish employee_advocacy_share, options
    case employee_advocacy_share.social_network
    when 'facebook'
      return publish_on_facebook employee_advocacy_share, options
    when 'twitter'
      return publish_on_twitter employee_advocacy_share, options
    when 'linkedin'
      return publish_on_linkedin employee_advocacy_share, options
    when 'instagram'
      return publish_on_instagram employee_advocacy_share, options
    when 'download'
      return
    else
      raise SocialNetworkNotImplemented("Rede social #{employee_advocacy_share.social_network.titleize} não foi implementada")
    end
  end

  def self.publish_on_instagram employee_advocacy_share, options
    link = get_short_link employee_advocacy_share, options

    resp = {
      employee_shared_at: Time.now,
      link: link,
    }

    add_share_json employee_advocacy_share, resp
  end

  def self.publish_on_facebook employee_advocacy_share, options
    base_url = options[:base_url]
    access_token = employee_advocacy_share.user.identities.facebook.first.access_token

    if where_to_publish = employee_advocacy_share.where_to_publish and where_to_publish.present? and where_to_publish != "self"
      access_token = employee_advocacy_share.user.get_facebook_pages_hash[where_to_publish]["access_token"]
    end

    client = FacebookClient.new(access_token)

    link = get_short_link employee_advocacy_share, options
    

    if d = Domain.get_current_domain and (employee_advocacy_share.employee_advocacy_post.url.present?)
      options = {
        link: link,
        message: employee_advocacy_share.user_content,
        picture: "#{base_url}#{employee_advocacy_share.employee_advocacy_post.image.url}",
        name: employee_advocacy_share.employee_advocacy_post.title,
        description: employee_advocacy_share.user_content,
        caption: employee_advocacy_share.employee_advocacy_post.url
      }

      id = client.post_timeline(options)

      resp = {
        id: id,
        employee_shared_at: Time.now
      }
      add_share_json employee_advocacy_share, resp
    else
      options = {
        url: "#{base_url}#{employee_advocacy_share.employee_advocacy_post.image.url}",
        caption: employee_advocacy_share.user_content,
      }

      id = client.post_photo(options)

      resp = {
        id: id,
        employee_shared_at: Time.now,
        type: :photo
      }
      add_share_json employee_advocacy_share, resp
    end

  end

  def self.publish_on_twitter employee_advocacy_share, options
    base_url = options[:base_url]

    message = employee_advocacy_share.user_content
    if d = Domain.get_current_domain and (employee_advocacy_share.employee_advocacy_post.url.present?)
      link = get_short_link employee_advocacy_share, options
      text = "#{message} - #{link}"
    else
      text = message
    end

    identity = employee_advocacy_share.user.identities.twitter.first

    access_token = identity.access_token
    access_token_secret = identity.access_token_secret
    consumer_key = identity.domain.twitter_app_id
    consumer_secret = identity.domain.twitter_app_secret

    client = Twitter::REST::Client.new do |config|
      config.consumer_key = consumer_key
      config.consumer_secret = consumer_secret
      config.access_token = access_token
      config.access_token_secret = access_token_secret
    end

    image = File.open employee_advocacy_share.employee_advocacy_post.image.file.file

    response = client.update_with_media(text, image)

    resp = {
      id: response.id,
      text: response.text,
      employee_shared_at: Time.now,
    }
    add_share_json employee_advocacy_share, resp
  end

  def self.publish_on_linkedin employee_advocacy_share, options
    base_url = options[:base_url]
    link = get_short_link employee_advocacy_share, options
    Rails.logger.info link
    text = employee_advocacy_share.user_content

    identity = employee_advocacy_share.user.identities.linkedin.first

    access_token = identity.access_token
    urn = "urn:li:person:#{identity.json["extra"]["raw_info"]["id"]}"
    access_token_secret = identity.access_token_secret
    consumer_key = identity.domain.linkedin_app_id
    consumer_secret = identity.domain.linkedin_app_secret

    client = LinkedinClient.new(access_token)
    
    if !employee_advocacy_share["post_json"]["url"].nil?
      media = "originalUrl"
      share_media_category = "ARTICLE"
      original_url = link

    else
      image_register_response = client.register_image(urn)
      media = "media"
      share_media_category = "IMAGE"
      original_url = image_register_response["value"]["asset"]
      upload_url = image_register_response["value"]["uploadMechanism"]["com.linkedin.digitalmedia.uploading.MediaUploadHttpRequest"]["uploadUrl"]

      Kernel.system "curl -i --upload-file #{Rails.root}/public/#{employee_advocacy_share.employee_advocacy_post.image.url} --header 'Authorization: Bearer #{access_token}' '#{upload_url}'"

    end    

    new_data = {
      "author" => "#{urn}",
      "lifecycleState" => "PUBLISHED",
      "specificContent" => {
          "com.linkedin.ugc.ShareContent" => {
              "shareCommentary" => {
                  "text" => "#{text}"
              },
              "shareMediaCategory" => "#{share_media_category}",
              "media" => [
                  {
                      "status" => "READY",
                      "description" => {
                          "text" => "#{employee_advocacy_share.employee_advocacy_post.content}"
                      },
                      "#{media}" => "#{original_url}",
                      "title" => {
                          "text" => "#{employee_advocacy_share.employee_advocacy_post.title}"
                      }
                  }
              ]
          }
      },
      "visibility" => {
          "com.linkedin.ugc.MemberNetworkVisibility" => "CONNECTIONS"
      }
    }

    response = client.add_share(new_data)

    Rails.logger.info response.to_json
    
    add_share_json employee_advocacy_share, JSON.parse(response.body).merge(employee_shared_at: Time.now)
  end

  def self.add_share_json employee_advocacy_share, obj
    if employee_advocacy_share.social_json.present?
      json = JSON.parse employee_advocacy_share.social_json
    else
      json = []
    end
    json << obj
    employee_advocacy_share.social_json = json.to_json
    employee_advocacy_share.save
  end

  def self.get_short_link employee_advocacy_share, options
    base_url = options[:base_url]
    real_link = Rails.application.routes.url_helpers.employee_advocacy_share_url(
      employee_advocacy_share, :host => base_url)

    us = UrlShortener.new(real_link)
    us.title = employee_advocacy_share.employee_advocacy_post.title
    us.description = employee_advocacy_share.user_content

    if employee_advocacy_share.employee_advocacy_post.image.file.exists?
      us.picture = "#{base_url}#{employee_advocacy_share.employee_advocacy_post.image.url}"
    end

    us.short
  end

end

