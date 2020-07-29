class FacebookAnalyticsInfo < AnalyticsInfo

  BASE_GRAPH_URL = "https://graph.facebook.com/v2.8"
  FB_METRIC_DATETIME_FORMAT = "%FT%T%z"

  def access_token
    if @access_token.nil?
      @access_token = FacebookHelper.get_access_token @user, @domain
    end

    @access_token
  end

  def page_id
    if @page_id.nil?
      @page_id = @user.facebook_page_id_to_monitor

      # O usuário que não passou na escolha da página deve passar nesse metodo
      # e pegar a primeira pagina
      if not @page_id.present?
        response = HTTParty.get(
          BASE_GRAPH_URL + "/me/accounts",
          query: {
            access_token: access_token
          }
        )

        json = JSON.parse response.body
        if json["data"].present? and json["data"].size > 0
          @page_id = json["data"].first['id']
          @user.facebook_page_id_to_monitor = @page_id
          @user.save
        else
          raise NoPageFound.new("No page found for user #{response.request.last_uri.to_s} #{response.body}")
        end
      end

    end

    @page_id
  end

  # tem dado que o facebook não traz do dia atual
  # então preenche esses gaps com 0
  def sanitize values, begin_date, end_date
    (begin_date..end_date).step(1).map do |d|
      results_for_date = values.select do |value|
        DateTime.parse(value["end_time"]).to_date == d
      end

      if results_for_date.any?
        results_for_date.first
      else
        {
          "end_time" => d.strftime(FB_METRIC_DATETIME_FORMAT),
          "value" => 0
        }
      end
    end.map do |d|
      [
        DateTime.parse(d["end_time"]).strftime("%F"),
        d["value"]
      ]
    end
  end

  def get_data begin_date, end_date, metrics=nil
    if metrics.nil?
      metrics = %W(
        page_fans page_positive_feedback_by_type page_actions_post_reactions_total
        page_stories page_engaged_users page_impressions_unique page_fans_gender_age
      )
    end

    date_key = "#{begin_date.strftime("%Y%m%d")}#{end_date.strftime("%Y%m%d")}}#{metrics.join("")}"

    if @datas.nil?
      @datas = {}
    end

    if end_date
      end_date += 1.day
    end

    if @datas[date_key].nil?
      response = HTTParty.get(
        BASE_GRAPH_URL + "/#{page_id}/insights",
        query: {
          access_token: access_token,
          metric: metrics.join(","),
          since: begin_date.strftime(TIME_FORMAT),
          until: end_date.strftime(TIME_FORMAT)
        }
      )
      @datas[date_key] = JSON.parse response.body
    end

    @datas[date_key]
  end

  def followers_evolution begin_date, end_date
    json = get_data begin_date, end_date

    if json["data"].present? and json["data"].count > 0
      metric_data = json["data"].select do |metric|
        metric["name"] == "page_fans" && metric["period"] == 'lifetime'
      end

      metric_data = metric_data.first

      return sanitize(metric_data["values"], begin_date, end_date)
    end
  end

  def reach begin_date, end_date
    json = get_data begin_date, end_date

    if json["data"].present? and json["data"].count > 0
      metric_data = json["data"].select do |metric|
        metric["name"] == "page_impressions_unique" && metric["period"] == 'day'
      end

      metric_data = metric_data.first

      return sanitize(metric_data["values"], begin_date, end_date)
    end
  end

  def page_stories begin_date, end_date
    json = get_data begin_date, end_date

    if json["data"].present? and json["data"].count > 0

      metric_data = json["data"].select do |metric|
        metric["name"] == "page_stories" && metric["period"] == 'day'
      end

      metric_data = metric_data.first

      return sanitize(metric_data["values"], begin_date, end_date)
    end
  end

  def gender begin_date, end_date
    metrics = %W(
      page_fans_gender_age
    )
    json = get_data 1.day.ago.to_date, Time.now.to_date, metrics

    if json["data"].present? and json["data"].count > 0

      metric_data = json["data"].select do |metric|
        metric["name"] == "page_fans_gender_age" && metric["period"] == 'lifetime'
      end

      metric_data = metric_data.first
      male = 0
      female = 0

      if metric_data and metric_data["values"]
        values = metric_data["values"].select do |v|
          v["value"].present?
        end

        value_obj = values.last

        if value_obj["value"].present?
          value_obj["value"].keys.each do |k|
            if k[0] == "M"
              male += value_obj["value"][k]
            else
              female += value_obj["value"][k]
            end
          end
        end
      end

      total = male + female

      if total > 0
        to_return = {
          male: (male.to_f / total) * 100,
          female: (female.to_f / total) * 100,
          unknown: 0,
        }
      else
        to_return = nil
      end

      return to_return
    end
  end

  def engagement
    json = get_data @start_date, @end_date

    if json["data"].present? and json["data"].count > 0

      metric_data = json["data"].select do |metric|
        metric["name"] == "page_engaged_users" && metric["period"] == 'day'
      end

      metric_data = metric_data.first

      count = sanitize(metric_data["values"], @start_date, @end_date).inject(0) do |memo, d|
        memo + d.last
      end

      return count
    end
  end

  def fetch
    posts = page_stories(@start_date, @end_date).inject(0) do |memo, d|
      memo + d.last
    end
    reach_sum = reach(@start_date, @end_date).inject(0) do |memo, d|
      memo + d.last
    end

    {
      followers_evolution: followers_evolution(@start_date, @end_date),
      posts: posts,
      engagement: engagement,
      reach_sum: reach_sum,
      reach: reach(@start_date, @end_date),
      interactions_evolution: page_stories(@start_date, @end_date),
      gender: gender(@start_date, @end_date),
    }
  end

end
