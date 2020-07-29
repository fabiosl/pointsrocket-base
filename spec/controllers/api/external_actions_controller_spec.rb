require 'rails_helper'

RSpec.describe Api::ExternalActionsController, :type => :controller do

  let(:domain) {
    create(:domain)
  }

  let(:text) {
    attrs = build(:external_action).text
  }

  describe "logged" do
    before do
      login_user
    end

    describe "POST create" do
      it "creates a new external_action" do
        expect {
          post :create, {text: text, current_domain_id: domain.id}
        }.to change(ExternalAction, :count).by(1)
      end

      it "assigns a newly created external_action as @external_action" do
        post :create, {text: text, current_domain_id: domain.id}
        expect(assigns(:external_action)).to be_a(ExternalAction)
        expect(assigns(:external_action)).to be_persisted
      end
    end
  end

end
