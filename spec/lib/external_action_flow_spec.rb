require 'rails_helper'

RSpec.describe ExternalActionFlow do

  class DummyExternalAction
    def initialize *args
    end

    def run
    end
  end

  let(:domain) {
    create(:domain,
      external_actions_rns: "DummyExternalAction")
  }

  let(:external_action) { create(:external_action, text: "", domain: domain) }

  subject { described_class.new(external_action) }

  it "calls dummy run" do
    expect_any_instance_of(DummyExternalAction).to receive(:run).once()
    subject.run
  end

end
