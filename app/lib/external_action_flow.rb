class ExternalActionFlow

  def initialize external_action
    @external_action = external_action
  end

  def run
    external_actions_rns = @external_action.domain.external_actions_rns
    if external_actions_rns.present?
      external_actions_rns.split(',').each do |rn|
        rn.constantize.new(@external_action).run
      end
    end
  end

end
