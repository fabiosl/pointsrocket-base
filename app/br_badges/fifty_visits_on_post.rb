class FiftyVisitsOnPost < VisitsOnPost

  def min_visits_count
    50
  end

  def badge_slug
    "fifty-clicks-on-post"
  end

end
