require 'google/apis/youtube_v3'

class YoutubeApiHelper

  class NoPermissionGranted < Exception ; end
  class NoChannelsFound < Exception ; end
  class YtError < Exception ; end

  def initialize user, domain
    @user = user
    @domain = domain
  end

  def get_channels
    domain = @domain.master_domain_or_self_for_provider :google_oauth2
    auth = GoogleHelper.authorization_for_user(@user, domain)
    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.authorization = auth
    channels = youtube.list_channels("id,snippet", mine: true).items

    if channels.size == 0
      raise NoChannelsFound.new
    end

    channels.map do |channel|
      {
        'id' => channel.id,
        'title' => channel.snippet.title,
        'thumbnails' => channel.snippet.thumbnails
      }
    end
  end

  def get_channel_info channel_id
    domain = @domain.master_domain_or_self_for_provider :google_oauth2
    auth = GoogleHelper.authorization_for_user(@user, domain)
    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.authorization = auth
    data = youtube.list_channels("id,snippet", id: channel_id)
    if data.items.present?
      channels = data.items.select do |channel|
        channel.id == channel_id
      end

      if channels.size > 0
        return channels.first
      end
    end

    raise Exception("No channel found for id #{channel_id}")
  end

end
