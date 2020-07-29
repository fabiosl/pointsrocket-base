class ChallengeUserApproved < BrBadge
  def run
    challenge_user = @args[0]

    if challenge_user.status == "approved" && challenge_user.challenge.badge
      if not challenge_user.user.has_badge? challenge_user.challenge.badge
        challenge_user.user.add_badge(challenge_user.challenge.badge)

        @badges_added = [challenge_user.challenge.badge]
      end
    end
  end
end
