class NewsAnalytics
  class NoInteractionsFoundForUser < Exception ; end

  attr_accessor :shares

  def initialize
  end

  def load
    @shares ||= EmployeeAdvocacyShare.all.decorate
  end

  def proccess
    {
      total_cost: total_cost
    }
  end

  def total_post
    load.count
  end

  def get_json hcu
    JSON.parse(hcu.json)
  end

  def total_cost
    load.inject(0) do |memo, item|
      memo + item.get_cost
    end
  end

  def total_interactions
    0
  end

  def good_interactions
    with_interactions.inject(0) do |memo, hcu_hash|
      memo + hcu_hash[:interaction_count][:good]
    end
  end

  def bad_interactions
    with_interactions.inject(0) do |memo, hcu_hash|
      memo + hcu_hash[:interaction_count][:bad]
    end
  end

  def potential_reach
    hash = load.inject({}) do |memo, hcu|
      begin
        author_followers = hcu.author_followers
        author_id = hcu.author_id
        memo[author_id] ||= 0
        if memo[author_id] < author_followers
          memo[author_id] = author_followers
        end
      rescue EmployeeAdvocacyShareDecorator::NoAuthorFollowersPresent => e
      end

      memo
    end

    hash.keys.inject(0) do |memo, key|
      memo += hash[key]
    end
  end

  def potential_impact
    load.inject(0) do |memo, hcu|
      begin
        memo += hcu.author_followers
      rescue EmployeeAdvocacyShareDecorator::NoAuthorFollowersPresent => e
      end

      memo
    end
  end

  def with_interactions
    @with_interactions ||= load.map do |share|
      {
        share: share,
        interaction_count: share.interaction_count,
      }
    end
  end

  def sorted_by_interactions_total
    with_interactions.sort do |a, b|
      a[:interaction_count][:total] <=> b[:interaction_count][:total]
    end.map do |i|
      i[:share]
    end
  end

  def top_publications count=3
    sorted_by_interactions_total.reverse[0..(count - 1)]
  end

  def down_publications count=3
    sorted_by_interactions_total[0..(count - 1)]
  end

  def group_by_user_interaction_sorted_by_interactions_total
    h = with_interactions.inject({}) do |memo, h|
      user = h[:share].user
      memo[user.id] ||= {
        total: 0,
        good: 0,
        bad: 0,
        user: user,
        eemv: {
          facebook: 0,
          twitter: 0,
          linkedin: 0,
          total: 0
        },
        shares: [],
      }
      memo[user.id][:total] += h[:interaction_count][:total]
      memo[user.id][:good] += h[:interaction_count][:good]
      memo[user.id][:bad] += h[:interaction_count][:bad]
      memo[user.id][:shares] << h[:share]

      n = h[:share].social_network.to_sym

      if n.present?
        memo[user.id][:eemv][n] += h[:share].get_cost
        memo[user.id][:eemv][:total] += h[:share].get_cost
      end

      memo
    end

    h.keys.map do |k|
     h[k]
    end.sort do |a, b|
      a[:total] <=> b[:total]
    end.reverse.each_with_index.map do |k, i|
      k[:position] = i
      k
    end.reverse
  end

  def get_user_interactions user
    user_h = group_by_user_interaction_sorted_by_interactions_total.find do |h|
      h[:user] == user
    end

    raise NoInteractionsFoundForUser.new("No interactions was found for user #{user.id}") if user_h.nil?

    user_h
  end

  def most_engaged_user count=3
    group_by_user_interaction_sorted_by_interactions_total.reverse[0..(count - 1)]
  end

  def worst_engaged_user count=3
    group_by_user_interaction_sorted_by_interactions_total[0..(count - 1)]
  end

  def eemv_evolution
    if load.any?
      first_date = load.min_by do |hcu|
        hcu.created_at.beginning_of_day
      end.created_at

      last_date = load.max_by do |hcu|
        hcu.created_at
      end.created_at.end_of_day

      dates_map = []
      the_date = first_date.dup
      while the_date.end_of_day <= last_date
        dates_map << {
          start: the_date.beginning_of_day,
          end: the_date.end_of_day,
        }

        the_date += 1.day
      end

      dates_map = dates_map.each do |date_map|
        date_map[:items] = load.select do |hcu|
          hcu.created_at >= date_map[:start] and hcu.created_at <= date_map[:end]
        end

        date_map[:eemv] = date_map[:items].inject(0) do |memo, hcu|
          json = get_json(hcu)

          if json['_source']['cost'].present?
            memo += json['_source']['cost']
          end

          memo
        end

      end

      dates_map
    end
  end

  def self.for_all_shares
    obj = new
    obj.shares = EmployeeAdvocacyShare.all.decorate
    obj
  end

  def self.for_social_publications network
    obj = new
    obj.shares = EmployeeAdvocacyShare.all.where(social_network: network).decorate
    obj
  end

  def self.for_user user
    obj = new
    obj.shares = EmployeeAdvocacyShare.where(user: user).decorate
    obj
  end
end
