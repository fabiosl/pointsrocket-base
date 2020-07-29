module CacheFacebookPage
  extend self

  def get_fb_pages user
    Sidekiq.redis do |redis|
      if redis.get("#{user.id}_fb_pages_cache").present?
        return JSON.parse redis.get("#{user.id}_fb_pages_cache")
      else
        pages = GraphFacebookPages.new(user, Domain.get_current_domain).get_pages
        redis.set("#{user.id}_fb_pages_cache", pages.to_json)
        redis.expire("#{user.id}_fb_pages_cache", 15.minutes.to_i)
        return pages
      end
    end
  end
end
