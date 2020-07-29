class Dashboard::RankingController < DashboardController

  helper_method :most_recognized_by_hashtags

  def index
    @users = filter_users params[:date]
    @most_recognized_by_hashtags_data = most_recognized_by_hashtags
    @current_user_ranking = get_current_user_ranking @users
  end

  def filter
    @users = filter_users params[:date]
    @most_recognized_by_hashtags_data = get_peer_recognition_data params[:date]
    @current_user_ranking = get_current_user_ranking @users

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def filter_users period='all'
    total_users_limit = 5
    
    if ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'false'
      users_query = User.all.not_admin
    else
      users_query = User.domain(current_domain).not_admin
    end
    
    if ['last_24_hours', 'last_7_days', 'last_month'].include? period
      users = users_query.ranking(period)
    else
      users = users_query.total_points_received()
    end

    users.limit(total_users_limit)
  end

  def get_current_user_ranking users
    total_users_limit = 5

    current_user_position = (
      users.index { |item| item.id == current_user.id } || -1
    ) + 1

    current_user_ranking = {
      user: current_user.decorate,
      position: current_user_position,
      visible_in_ranking: current_user_position <= total_users_limit,
      is_next_position: current_user_position == total_users_limit + 1
    }
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

  def get_peer_recognition_data period='all'
    most_recognized_by_hashtags_data = {}
    if period == 'all'
      most_recognized_by_hashtags_data = most_recognized_by_hashtags
    else
      if period == 'last_24_hours'
        date_start = 1.day.ago.to_s
      elsif period == 'last_7_days'
        date_start = 7.days.ago.to_s
      else
        date_start = 1.month.ago.to_s
      end
  
      date_end = Time.now.to_s
      most_recognized_by_hashtags_data = most_recognized_by_hashtags date_start, date_end
    end
    most_recognized_by_hashtags_data
  end
end
