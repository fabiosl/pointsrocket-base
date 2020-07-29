require 'google/apis/youtube_v3'
require 'google/apis/youtube_analytics_v1'

class YoutubeAnalyticsInfo < AnalyticsInfo

  class NoChannelFound < Exception ; end

  def auth
    if @auth.nil?
      @auth = GoogleHelper.authorization_for_user @user, @domain
    end

    @auth
  end

  def youtube_analytics_client
    if @youtube_analytics_client.nil?
      @youtube_analytics_client = Google::Apis::YoutubeAnalyticsV1::YouTubeAnalyticsService.new
      @youtube_analytics_client.authorization = auth
    end

    @youtube_analytics_client
  end

  def get_channel_id
    # por hora retornar o primeiro canal
    if @channel_id.nil?
      @channel_id = @user.youtube_channel_id_to_monitor

      if not @channel_id.present?

        youtube = Google::Apis::YoutubeV3::YouTubeService.new
        youtube.authorization = auth
        @channel_id = youtube.list_channels("id", mine: true).items.first.id

        if @channel_id.present?
          @user.youtube_channel_id_to_monitor = @channel_id
          @user.save
        else
          raise NoChannelFound.new("User has no channel selected")
        end
      end
    end

    @channel_id
  end

  def yreach begin_date, end_date
    result = youtube_analytics_client.query_report(
      "channel==#{get_channel_id}",
      begin_date.strftime(TIME_FORMAT),
      end_date.strftime(TIME_FORMAT),
      "views",
      dimensions: "day"
    )

    sanitize result, begin_date, end_date
  end


  def yinteractions_evolution begin_date, end_date
    result = youtube_analytics_client.query_report(
      "channel==#{get_channel_id}",
      begin_date.strftime(TIME_FORMAT),
      end_date.strftime(TIME_FORMAT),
      "views,comments,likes,dislikes,shares,subscribersGained,subscribersLost",
      dimensions: "day"
    )

    sum_all(sanitize(result, begin_date, end_date))
  end

  def sum_all data
    if not data.present?
      return data
    end
    data.map do |d|
      [
        d[0],
        d[1..-1].inject(0, :+)
      ]
    end
  end

  def ygender begin_date, end_date
    result = youtube_analytics_client.query_report(
      "channel==#{get_channel_id}",
      begin_date.strftime(TIME_FORMAT),
      end_date.strftime(TIME_FORMAT),
      "viewerPercentage",
      dimensions: "gender"
    )

    if result.rows
      data = result.rows.inject({}) do |memo, d|
        memo[d[0]] = d[1]
        memo
      end

      if data["unknown"].nil?
        data['unknown'] = 0
      end

      data
    else
      nil
    end
  end

  def yfollowers_evolution begin_date, end_date
    result = youtube_analytics_client.query_report(
      "channel==#{get_channel_id}",
      begin_date.strftime(TIME_FORMAT),
      end_date.strftime(TIME_FORMAT),
      "subscribersGained,subscribersLost",
      dimensions: "day"
    )

    sanitize result, begin_date, end_date
  end

  # tem dado que o google não traz quando ele é zerado
  # então preenche esses gaps com 0
  def sanitize result, begin_date, end_date
    if result.respond_to? :rows
      rows = result.rows || []

      (begin_date.to_datetime..end_date.to_datetime).map do |d|
        results_for_date = rows.select do |i|
          i[0] == d.strftime(TIME_FORMAT)
        end

        if results_for_date.any?
          results_for_date.first
        else
          [d.strftime(TIME_FORMAT)] + ( result.column_headers.length - 1 ).times.map { 0 }
        end
      end
    else
      result
    end
  end

  def fetch
    {
      followers_evolution: yfollowers_evolution(@start_date, @end_date),
      reach: yreach(@start_date, @end_date),
      interactions_evolution: yinteractions_evolution(@start_date, @end_date),
      gender: ygender(Date.parse("2012-01-01"), Time.now.to_date),
    }
  end

end
