class BrBadge
  attr_reader :badges_added

  def initialize event, domain, *args
    @event = event
    @domain = domain
    @args = args
    @badges_added = []
  end

  def run
  end
end
