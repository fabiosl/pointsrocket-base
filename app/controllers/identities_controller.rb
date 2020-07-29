class IdentitiesController < ApplicationController
  controller_base
  controller_destroy

  def destroy
    Sidekiq.redis do |redis|
      provider = get_resource.provider
      key = nil
      if provider.to_s == "google_oauth2"
        key = "#{current_user.id}_yt_channels_cache"
      elsif provider.to_s == "facebook"
        key = "#{current_user.id}_fb_pages_cache"
      end

      # clear social account cache
      if key.present?
        redis.del(key)
      end
    end
    controller_action_destroy false
    redirect_to request.referer
  end
end
