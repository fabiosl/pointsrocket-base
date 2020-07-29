class InstagramAnalyticsInfo < AnalyticsInfo
  def fetch
    {
      followers_evolution: followers_evolution(50),
      reach: reach(50),
      interactions_evolution: interactions_evolution(50),
      gender: gender(3),
    }
  end
end
