require 'rails_helper'

RSpec.describe ExternalActionBase do

  context "get_tokens" do
    let(:external_action) { create(:external_action, text: "field=value=value%S%field2=value=value%S%field3=value=value") }

    subject { described_class.new(external_action).get_tokens }

    it "return correct token" do
      expect(subject).to eql({
        'field' => 'value=value',
        'field2' => 'value=value',
        'field3' => 'value=value',
      })
    end
  end


end
