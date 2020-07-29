class TenVisitsOnPost < VisitsOnPost

  def min_visits_count
    10
  end

  def badge_slug
    "ten-clicks-on-post"
  end
end
