class GraphFacebook
  FACEBOOK_GRAPH_API_BASE = 'https://graph.facebook.com/v2.8'

  def initialize access_token
    @access_token = access_token
  end

  def get_page_info page_id
    response = HTTParty.get(
      "#{FACEBOOK_GRAPH_API_BASE}/#{page_id}",
      headers: {
        "Accept" => "application/json",
      },
      query: {
        fields: "picture,name",
        access_token: @access_token
      }
    )

    if response.parsed_response["error"].present?
      raise Exception.new(response.parsed_response["error"]["message"])
    else
      response.parsed_response
    end
  end

  def get path, query=nil
    final_query = {
      access_token: @access_token,
      include_headers: false
    }

    final_query.merge!(query) if query

    response = HTTParty.get(
      "#{FACEBOOK_GRAPH_API_BASE}#{path}",
      :query => final_query
    )

    ap "finished get #{response.request.last_uri.to_s}"

    JSON.parse response.body
  end

  def get_pages
    get("/me/accounts")
  end

  def get_permissions
    get("/me/permissions")
  end

  def get_insights_for_page page_id
    days = 2
    start_date = days.days.ago.beginning_of_day.to_datetime.change(:offset => "-0300")
    end_date = Time.now.end_of_day.to_datetime.change(:offset => "-0300")

    metric = %W(
      page_fans page_positive_feedback_by_type page_actions_post_reactions_total
      page_stories page_engaged_users page_impressions_unique
    ).join(',')

    json = get("/#{page_id}/insights", {
      metric: metric,
      since: start_date.to_formatted_s(:iso8601),
      until: end_date.to_formatted_s(:iso8601)
    })

    last_comments_count = nil
    last_likes = nil
    reactions_count = nil
    page_stories = nil
    yesterday_engagement = nil
    yesterday_reach = nil

    json["data"].each do |metric_data|
      if metric_data["name"] == "page_positive_feedback_by_type" and metric_data["period"] == "day"
        last_comments_count = metric_data["values"].inject(0) do |memo, item|
          memo += item["value"]["comment"]
          memo
        end
      end

      if metric_data["name"] == "page_fans" and metric_data["period"] == "lifetime"
        last_likes = metric_data["values"]
      end

      if metric_data["name"] == "page_actions_post_reactions_total" and metric_data["period"] == "day"
        reactions_count = metric_data["values"].inject(0) do |memo, item|
          memo + item["value"].keys.inject(0) do |memo, reaction_key|
            memo + item["value"][reaction_key]
          end
        end
      end

      if metric_data["name"] == "page_stories" and metric_data["period"] == "day"
        page_stories = metric_data["values"].inject(0) do |memo, item|
          memo + item["value"]
        end
      end

      if metric_data["name"] == "page_engaged_users" and metric_data["period"] == "day"
        yesterday_engagement = metric_data["values"].last["value"]
      end

      if metric_data["name"] == "page_impressions_unique" and metric_data["period"] == "day"
        yesterday_reach = metric_data["values"].last["value"]
      end
    end

    {
      last_likes: last_likes,
      last_comments_count: last_comments_count,
      reactions_count: reactions_count,
      page_stories: page_stories,
      yesterday_engagement: yesterday_engagement,
      yesterday_reach: yesterday_reach,
    }
  end
end
