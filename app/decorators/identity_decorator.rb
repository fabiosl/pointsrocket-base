class IdentityDecorator < Draper::Decorator
  delegate_all
  include Rails.application.routes.url_helpers

  def social_url
    case object.provider
    when 'facebook'
      return "https://facebook.com/#{object.uid}"
    when 'twitter'
      return object.json["info"]["urls"]["Twitter"]
    when 'linkedin'
      return "https://www.linkedin.com/in/#{object.json["extra"]["raw_info"]["vanityName"]}"
    when 'google_oauth2'
      begin
        return object.json["info"]["urls"]["Google"]
      rescue Exception => e
        return ""
      end
    when 'instagram'
      return "https://instagram.com/#{object.json["info"]["nickname"]}"
    else
      return ""
    end
  end

  def social_ico
    return 'youtube' if object.provider == 'google_oauth2'
    object.provider
  end

end
