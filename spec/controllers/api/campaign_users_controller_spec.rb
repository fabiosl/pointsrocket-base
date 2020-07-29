require 'rails_helper'

RSpec.describe Api::CampaignUsersController, :type => :controller do

  render_views

  before do
    create(:domain, default: true)
  end

  let(:campaign) { create(:campaign) }
  let(:user) { create(:user) }

  let(:valid_attributes) {
    {
      campaign_id: campaign.id
    }
  }

  describe "logged with normal user" do
    before do
      login_user user
    end

    describe "POST create" do
      it "creates a new campaign_user" do
        expect {
          post :create, {campaign_user: valid_attributes}
        }.to change(CampaignUser, :count).by(1)
      end

      it "assigns a newly created campaign_user as @campaign_user" do
        post :create, {campaign_user: valid_attributes}
        expect(assigns(:campaign_user)).to be_a(CampaignUser)
        expect(assigns(:campaign_user)).to be_persisted
      end
    end

  end


end
