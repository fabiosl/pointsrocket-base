module TriggerEventsHelper
  def get_badges_added_from_trigger_events trigger_events
    trigger_events.flat_map do |trigger_event|
      trigger_event.br_badges.flat_map do |br_badge|
        br_badge.badges_added
      end
    end.uniq
  end
end
