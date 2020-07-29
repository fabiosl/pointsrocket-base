class HashtagsEvolutionFlow
  attr_accessor :data_time_range

  def initialize domain
    @domain = domain
  end

  def timeline_data_evolution
    self.data_time_range = 5.days.ago.to_datetime..Time.now
    get("all", "daily")
  end

  def get period, group
    data = get_data_by_period period
    group_data data, group
  end

  def group_data data, group
    case group
    when "daily"
      date_trunc = 'day'
      diff = 1
    when "weekly"
      date_trunc = 'week'
      diff = 7
    when "monthly"
      date_trunc = 'month'
      diff = 30
    else
      raise Exception.new("Group not found => #{group}")
    end

    result = data.each do |item|
      item[:data] = item[:data].group(
        "date_trunc('#{date_trunc}', created_at at time zone '-03')")
    end
      
    result = result.each do |item|
      item[:data] = item[:data].sum('points')
    end

    dates = []
    result.each do |item|
      dates += item[:data].keys.sort
    end


    if data_time_range.nil?
      data_time_range = dates.first.to_date..Date.today
    end

    data_time_range.step(diff).each do |timestamp|
      datetime = timestamp.to_datetime
      if dates.include? datetime
        result.each do |item|
          if not item[:data].keys.include? datetime
            item[:data][datetime] = 0
          end
        end
      end
    end

    result
  end

  def get_data_by_period period
    if not @data_time_range
      case period
      when "this_month"
        @data_time_range = Time.now.beginning_of_month..Time.now.end_of_month
      when "this_year"
        @data_time_range = Time.now.beginning_of_year..Time.now.end_of_year
      when "all"
        @data_time_range = nil
      else
        raise Exception.new("Period not found => #{period}")
      end
    end
    
    data = CoinUser.top_hashtags.take(6).map do |item|
      if @data_time_range
        {
          hashtag: item[:hashtag],
          data: CoinUser.where(created_at: @data_time_range).where("'#{item[:hashtag]}' = ANY (hashtags)")
        }
      else
        {
          hashtag: item[:hashtag],
          data: CoinUser.where("'#{item[:hashtag]}' = ANY (hashtags)")
        }
      end
    end

    data
  end
end
