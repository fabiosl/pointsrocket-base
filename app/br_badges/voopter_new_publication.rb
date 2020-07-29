class VoopterNewPublication < BrBadge

  def run
    hashtag_challenge_user = @args.first
    user = hashtag_challenge_user.user

    begin
      ap "runing"
      badge = Badge.find badge_id

      ap badge
      ap "user has badge #{user.has_badge? badge}"

      if not user.has_badge? badge
        ap "adding badge for user"
        user.add_badge badge
        user.generate_sum_points
        @badges_added << badge
      end
    rescue ActiveRecord::RecordNotFound => e
      ap e.message
      ap e.backtrace
    end

  end

  def badge_id
    1
  end
end
