class MoipCloseCallExternalAction < ExternalActionBase

  def run
    tokens = get_tokens
    type = tokens['type']

    if type != 'moip_close_call'
      ap "MoipCloseCallExternalAction recebeu #{tokens} mas passou"
      return false
    end

    ap "MoipCloseCallExternalAction recebeu #{tokens} e está executando"

    email = tokens['email']
    badge = Badge.all.tagged_with(
      @external_action.domain.tags,
      any: true).where(
        slug: 'moip-close-call'
      ).first

    user = User.where(email: email).first

    if not badge.present?
      ap "MoipCloseCallExternalAction badge com slug moip-close-call não está presente com tags #{@external_action.domain.tags}"
      return false
    end

    if not user.present?
      ap "MoipCloseCallExternalAction user com email #{email} não está presente."
      return false
    end

    user.add_badge(badge)

    return true

  end

end
