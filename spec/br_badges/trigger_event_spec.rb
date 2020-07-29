require 'rails_helper'

RSpec.describe TriggerEvent do

  class DummyBrBadgeTriggerEvent < BrBadge
  end

  let(:domain) { create(:domain) }

  let(:event) { "event_name" }
  let(:args) { [domain] }

  subject { described_class.new.run(event, *args) }

  context "with domain br badge that matchs dummy" do

    let!(:domain_br_badge_event) {
      create(:domain_br_badge_event, {
        domain: domain,
        event: event,
        br_badge: DummyBrBadgeTriggerEvent.name,
      })
    }

    it "calls dummy br badge" do
      expect_any_instance_of(DummyBrBadgeTriggerEvent).to receive(:run)
      subject
    end

  end

  context "with domain br badge that not matchs dummy" do

    it "calls dummy br badge" do
      expect_any_instance_of(DummyBrBadgeTriggerEvent).not_to receive(:run)
      subject
    end

  end


end
