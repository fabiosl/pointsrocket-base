class Dashboard::AdminDashboardController < DashboardController
  def index
  end

  def peer_recognition
    @dashboard_data = {
      hashtags_evolution: HashtagsEvolutionFlow.new(current_domain).get('all', 'weekly')
    }
  end

  def hashtag_challenges
    hca = HashtagChallengeAnalytics.for_all_publications
    hca_facebook = HashtagChallengeAnalytics.for_social_publications :facebook
    hca_instagram = HashtagChallengeAnalytics.for_social_publications :instagram
    hca_youtube = HashtagChallengeAnalytics.for_social_publications :youtube

    @dashboard_data = {
      hashtag_challenge_total_post: hca.total_post,
      hashtag_challenge_total_cost: hca.total_cost,
      hashtag_challenge_total_interactions: hca.total_interactions,
      potential_impact: hca.potential_impact,
      potential_reach: hca.potential_reach,
      facebook_cost: hca_facebook.total_cost,
      instagram_cost: hca_instagram.total_cost,
      eemv_evolution: hca.eemv_evolution,
      youtube_cost: hca_youtube.total_cost,
      top_publications: hca.top_publications(4),
      down_publications: hca.down_publications(4),
      most_engaged_user: hca.most_engaged_user(5),
      worst_engaged_user: hca.worst_engaged_user(5),
    }
  end

  def news
    na = NewsAnalytics.for_all_shares
    naf = NewsAnalytics.for_social_publications :facebook
    nal = NewsAnalytics.for_social_publications :linkedin
    nat = NewsAnalytics.for_social_publications :twitter

    @dashboard_data = {
      total_cost: 0,
      total_interactions: 0,
      total_post: 0
    }

    @dashboard_data.merge!({
      total_cost: na.total_cost + @dashboard_data[:total_cost],
      total_interactions: na.total_interactions + @dashboard_data[:total_interactions],
      total_post: na.total_post + @dashboard_data[:total_post],
      news_total_cost: na.total_cost,
      news_facebook_total_cost: naf.total_cost,
      news_twitter_total_cost: nat.total_cost,
      news_linkedin_total_cost: nal.total_cost,
      total_clicks: EmployeeAdvocacyVisit.count,
      total_news_shares: EmployeeAdvocacyShare.count
    })
  end

  def general
    models = []
    if @domain.employee_advocacy_enabled
      models << EmployeeAdvocacyPost
    end

    if @domain.hashtag_challenges_enabled
      models << HashtagChallenge
    end

    if @domain.courses_enabled
      models << Course
    end

    if @domain.challenges_enabled
      models << Challenge
    end

    if @domain.broadcasts_enabled
      models << Broadcast
    end

    if @domain.campaigns_enabled
      models << Campaign
    end

    atr = ApplicationTableHelper2.new
    atr.models = models
    atr.get_data

    @dashboard_data = {
      atr: atr,
      total_cost: 0,
      total_interactions: 0,
      total_post: 0,
      points_evolution: PointsEvolutionFlow.new(current_user).get('all', 'weekly'),
      hashtags_evolution: HashtagsEvolutionFlow.new(current_domain).get('all', 'weekly'),
      top_engaged_users: User.top_engaged,
      least_engaged_users: User.least_engaged,
    }

    if @domain.employee_advocacy_enabled
      na = NewsAnalytics.for_all_shares
      naf = NewsAnalytics.for_social_publications :facebook
      nal = NewsAnalytics.for_social_publications :linkedin
      nat = NewsAnalytics.for_social_publications :twitter

      @dashboard_data.merge!({
        total_cost: na.total_cost + @dashboard_data[:total_cost],
        total_interactions: na.total_interactions + @dashboard_data[:total_interactions],
        total_post: na.total_post + @dashboard_data[:total_post]
      })
    end

    if @domain.hashtag_challenges_enabled
      hca = HashtagChallengeAnalytics.for_all_publications
      hca_facebook = HashtagChallengeAnalytics.for_social_publications :facebook
      hca_instagram = HashtagChallengeAnalytics.for_social_publications :instagram
      hca_youtube = HashtagChallengeAnalytics.for_social_publications :youtube
      @engagement_user_data = get_engagement_user_data(hca)

      @dashboard_data.merge!({
        total_cost: hca.total_cost + @dashboard_data[:total_cost],
        total_interactions: hca.total_interactions + @dashboard_data[:total_interactions],
        total_post: hca.total_post + @dashboard_data[:total_post]
      })
    else
      @engagement_user_data = get_engagement_user_data
    end
  end

  def filter_peer_recognition
    date_start= params[:peer_recognition_date_start]
    date_end = params[:peer_recognition_date_end]
    @most_recognized_by_hashtags_data = most_recognized_by_hashtags date_start, date_end
    @top_hashtags_data = top_hashtags date_start, date_end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def most_recognized_by_hashtags peer_recognition_date_start=nil, peer_recognition_date_end=nil
    data = {}
    if @domain.peer_recognition_enabled
      options = ["all"]
      options += @domain.peer_recognition_hashtags.split(",")
      options.each do |hashtag|
        most_recognized = CoinUser.most_recognized_by_hashtags hashtag, peer_recognition_date_start, peer_recognition_date_end
        data[hashtag] = most_recognized
      end
    end
    data
  end

  def top_hashtags peer_recognition_date_start=nil, peer_recognition_date_end=nil
    CoinUser.top_hashtags peer_recognition_date_start, peer_recognition_date_end
  end

  def get_engagement_user_data(hca=nil)

    if ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'false'
      users = User.not_admin
    else
      users = User.not_admin.domain(current_domain)
    end

    to_return = users.map do |user|
      to_ret = {
        user: user
      }
    end

    if hca.present?
      aux = hca.most_engaged_user(users.count)

      to_return = to_return.map do |to_ret|
        h = aux.find do |aux_i|
          aux_i[:user] == to_ret[:user]
        end

        if h
          to_ret.merge!(interactions: h[:total]).merge!(h)
        end

        to_ret
      end
    end

    to_return.sort do |a, b|
      (a[:interactions] || 0) <=> (b[:interactions] || 0)
    end.reverse
  end

  def engagement
    application_table = ApplicationTableHelper.new
    application_table.get_data
    hashtag_challenge_analytics = HashtagChallengeAnalytics.for_all_publications
    engagement_user_data = get_engagement_user_data(
      hashtag_challenge_analytics
    )

    social_network_permiteds = (@domain.social_network_permiteds || 'facebook').split(',')

    column_names = [
      I18n.t("excel.name"),
      I18n.t("excel.points"),
    ]

    if @domain.employee_advocacy_enabled or @domain.hashtag_challenges_enabled
      column_names << I18n.t("excel.interactions")
    end

    if @domain.hashtag_challenges_enabled
      column_names << I18n.t("excel.eemv")

      column_names.concat(
        social_network_permiteds.map do |n|
          I18n.t("excel.#{n}_eemv")
        end
      )
    end


    to_concat = []

    if @domain.hashtag_challenges_enabled
      to_concat << I18n.t("excel.posts_captureds")
      to_concat << I18n.t("excel.hashtag_challenges")
    end

    to_concat << I18n.t("excel.badges")

    if @domain.courses_enabled
      to_concat << I18n.t("excel.courses")
    end

    if @domain.challenges_enabled
      to_concat << I18n.t("excel.challenges")
    end

    if @domain.campaigns_enabled
      to_concat << I18n.t("excel.rewards")
    end

    if @domain.employee_advocacy_enabled
      to_concat << I18n.t("excel.news")
    end

    column_names.concat(to_concat).concat(
      application_table.head.map do |head|
        "#{application_table.get_title_of(head)}"
      end
    )

    data = [ column_names ]
    data += engagement_user_data.map do |user|
      na_user_interactions = nil

      if @domain.employee_advocacy_enabled
        begin
          na_user_interactions = NewsAnalytics.for_user(user[:user]).get_user_interactions(user[:user])
        rescue NewsAnalytics::NoInteractionsFoundForUser => e
          na_user_interactions = nil
        end
      end

      to_return = [
        user[:user].name,
        user[:user].sum_points,
      ]

      if @domain.employee_advocacy_enabled or @domain.hashtag_challenges_enabled
        interactions = 0

        if @domain.hashtag_challenges_enabled
          interactions += user[:total] || 0
        end

        if @domain.employee_advocacy_enabled
          interactions += na_user_interactions[:total] unless na_user_interactions.nil?
        end

        to_return << interactions
      end

      if @domain.hashtag_challenges_enabled
        to_return << user.dig(:eemv, :total) || 0

        social_network_permiteds.each do |n|
          slug = n == 'google_oauth2' ? "youtube" : n
          to_return << user.dig(:eemv, slug.to_sym) || 0
        end

        total = HashtagChallenge.count

        if user[:hcus].present?
          to_return << user[:hcus].size
          total_user = user[:hcus].map {|hcu| hcu.hashtag_challenge_id }.uniq.size
          to_return << I18n.t("excel.of", {value: total_user, of: total})
        else
          to_return << 0
          to_return << I18n.t("excel.of", {value: 0, of: total})
        end
      end

      to_return << I18n.t("excel.of", {value: user[:user].badge_users.count, of: Badge.count})

      if @domain.courses_enabled
        finished_courses_count = Course.all.select do |c|
          user[:user].finished_course? c
        end.size

        to_return << I18n.t("excel.of", {value: finished_courses_count, of: Course.count}) # Cursos
      end

      if @domain.challenges_enabled
        finished_challenges_count = Challenge.all.select do |c|
          user[:user].challenge_users.where(challenge: c).any?
        end.size

        to_return << I18n.t("excel.of", {value: finished_challenges_count, of: Challenge.count}) # Challenges
      end

      if @domain.employee_advocacy_enabled
        finished_employee_advocacy_posts_count = user[:user].employee_advocacy_shares.pluck('employee_advocacy_post_id').size

        to_return << I18n.t("excel.of", {value: finished_employee_advocacy_posts_count, of: EmployeeAdvocacyPost.count}) # Rewards
      end

      if @domain.campaigns_enabled
        finished_campaigns_count = Campaign.all.select do |c|
          user[:user].campaign_users.where(campaign: c).any?
        end.size

        to_return << I18n.t("excel.of", {value: finished_campaigns_count, of: Campaign.count}) # Rewards
      end

      to_return.concat(
        application_table_user_row(application_table, user[:user])
      )
    end

    if @domain.employee_advocacy_enabled
      data << []
      data << [I18n.t("excel.news")]
      data << [
        I18n.t("excel.content"),
        I18n.t("excel.created_at"),
        I18n.t("excel.from"),
        I18n.t("excel.social_network"),
        I18n.t("excel.post_url"),
        I18n.t("excel.news"),
        I18n.t("excel.clicks"),
        I18n.t("excel.reactions"),
      ]

      news_data = EmployeeAdvocacyShare.all.decorate.flat_map do |eas|
        if not eas.social_json
          []
        else
          json = JSON.parse(eas.social_json)
          if not json.respond_to? :map
            []
          else
            json.map do |social_item|
              reactions = 0

              case eas.social_network
              when "facebook"
                message = social_item.dig("json", "message") || ""
                post_url = "https://facebook.com/#{social_item["id"]}"

                reactions = ["like",
                  "wow",
                  "sad",
                  "love",
                  "haha",
                  "angry",
                  "thankful",
                  "pride",
                ].inject(0) do |memo, reaction|
                  memo + (social_item.dig("json", reaction.upcase, "summary", "total_count") || 0)
                end

                reactions += (social_item.dig("json", "comments", "summary", "total_count") || 0)

              when "twitter"
                message = social_item.dig("text") || social_item.dig("json", "message") || ""
                screen_name = social_item.dig("json", "user", "screen_name")
                status_id = social_item.dig('id') || social_item.dig('json', "id_str")

                if screen_name.present? and status_id.present?
                  post_url = "https://twitter.com/#{screen_name}/status/#{status_id}"
                else
                  # post_url = "screen_name: #{screen_name}, status_id: #{status_id}, share_id: #{eas.id}"
                  post_url = ""
                end

                reactions = ["retweet_count", "favorite_count"].inject(0) do |memo, metric|
                  memo + (social_item.dig("json", metric) || 0)
                end


              when "linkedin"
                post_url = social_item["updateUrl"]
                message = I18n.t('.excel.linkedin_message_failure')
              end

              # ap "aqui cacete"
              # ap social_item
              # ap social_item["employee_shared_at"]
              # ap DateTime.parse(social_item["employee_shared_at"])

              [
                message,
                DateTime.parse(social_item["employee_shared_at"]),
                eas.user.name,
                eas.social_network,
                post_url,
                eas.post_json["title"],
                eas.employee_advocacy_visits.count,
                reactions
              ]
            end
          end
        end
      end.sort_by {|i| i[1] }

      data += news_data
    end

    if @domain.hashtag_challenges_enabled
      data << []
      data << [I18n.t("excel.hashtag_challenges")]
      data << [
        I18n.t("excel.content"),
        I18n.t("excel.created_at"),
        I18n.t("excel.from"),
        I18n.t("excel.social_network"),
        I18n.t("excel.eemv"),
        I18n.t("excel.post_url"),
        I18n.t("excel.hashtag_challenge"),
        I18n.t("excel.hashtag_challenge_link"),
      ]

      hcu_data = HashtagChallengeUser.all.decorate.map do |hcu|
        if hcu.json.present?
          message = hcu.get_post_message
          created_at = hcu.post_created_at
          from = hcu.user.present? ? hcu.user.name : ""
          social_network = hcu.get_post_social_network
          eemv = hcu.get_cost
          post_url = hcu.get_post_url
          hashtag_challenge_title = hcu.hashtag_challenge.present? ? hcu.hashtag_challenge.title : ""
          the_url = hcu.hashtag_challenge.present? ? hashtag_challenge_url(hcu.hashtag_challenge) : ""

          [
            message,
            created_at,
            from,
            social_network,
            eemv,
            post_url,
            hashtag_challenge_title,
            the_url,
          ]
        else
          nil
        end
      end.select(&:present?).sort_by {|i| i[1] }

      data += hcu_data
    end

    end_part = "public/system/data-#{@domain.name}-#{Time.now.to_s(:db)}.xls"
    filepath = Rails.root.join(end_part)

    sw = SheetWriter.new
    sw.data = data
    sw.filepath = filepath
    sw.write

    redirect_to end_part.gsub('public', '')
  end

  helper_method :most_recognized_by_hashtags
  helper_method :top_hashtags

  def csv_points_sent_by_hashtags date_start=nil, date_end=nil
    headers = ['Hashtag', 'Remetente', 'Pontos']
    coins = CoinUser.filter_by_date_range(date_start, date_end)
    generated_csv = CSV.generate(headers: true) do |csv|
      csv << headers
      hashtags = @domain.peer_recognition_hashtags.split(",") 
      for hashtag in hashtags do
        data = coins
          .where("hashtags && ?", "{#{hashtag}}")
          .group("sender_id")
          .select("sender_id, SUM(points) AS total_points")
          .order("total_points DESC")
        for elem in data do
          if User.exists?(elem.sender_id)
            sender = User.find(elem.sender_id)
            csv << ["#{hashtag}", "#{sender.name}", "#{elem.total_points}"]
          end
        end
      end
    end
    send_data generated_csv, filename: "points_sent_by_hashtags.csv", disposition: :attachment
  end

  def generate_extract
    date_start = params[:extract_date_start]
    date_end = params[:extract_date_end]
    if params[:select_extract_content] == 'points_sent_by_hashtags'
      csv_points_sent_by_hashtags(date_start, date_end)
    elsif params[:select_extract_content] == 'points_received_by_hashtags'
      csv_points_received_by_hashtags(date_start, date_end)
    elsif params[:select_extract_content] == 'total_points_sent'
      csv_total_points_sent(date_start, date_end)
    elsif params[:select_extract_content] == 'total_points_received'
      csv_total_points_received(date_start, date_end)
    end
  end

  private

  def application_table_user_row(application_table, user)
    application_table.rows.each do |row|
      return row.slice(1..-1) if row[0].id == user.id
    end
  end

  def csv_points_received_by_hashtags date_start=nil, date_end=nil
    headers = ['Hashtag', 'Destinatario', 'Pontos']
    coins = CoinUser.filter_by_date_range(date_start, date_end)
    generated_csv = CSV.generate(headers: true) do |csv|
      csv << headers
      hashtags = @domain.peer_recognition_hashtags.split(",") 
      for hashtag in hashtags do
        data = coins
          .where("hashtags && ?", "{#{hashtag}}")
          .group("recipient_id")
          .select("recipient_id, SUM(points) AS total_points")
          .order("total_points DESC")
        for elem in data do
          if User.exists?(elem.recipient_id)
            recipient = User.find(elem.recipient_id)
            csv << ["#{hashtag}", "#{recipient.name}", "#{elem.total_points}"]
          end
        end
      end
    end
    send_data generated_csv, filename: "points_received_by_hashtags.csv", disposition: :attachment
  end

  def csv_total_points_sent date_start=nil, date_end=nil
    headers = ['Remetente', 'Pontos']
    coins = CoinUser.filter_by_date_range(date_start, date_end)
    generated_csv = CSV.generate(headers: true) do |csv|
      csv << headers
      data = coins.group("sender_id").sum("points")
      for elem in data
        if User.exists?(elem.first)
          user = User.find(elem.first)
          csv << ["#{user.name}", "#{elem.last}"]
        end
      end
    end
    send_data generated_csv, filename: "total_points_sent.csv", disposition: :attachment
  end

  def csv_total_points_received date_start=nil, date_end=nil
    headers = ['Destinatario', 'Pontos']
    coins = CoinUser.filter_by_date_range(date_start, date_end)
    generated_csv = CSV.generate(headers: true) do |csv|
      csv << headers
      data = CoinUser.group("recipient_id").sum("points")
      for elem in data
        if User.exists?(elem.first)
          user = User.find(elem.first)
          csv << ["#{user.name}", "#{elem.last}"]
        end
      end
    end
    send_data generated_csv, filename: "total_points_received.csv", disposition: :attachment
  end
end
