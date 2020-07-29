require 'rails_helper'

RSpec.describe Api::DevicesController, :type => :controller do

  render_views

  let(:user) {
    create(:user)
  }

  let(:valid_attributes) {
    build(:device, :ios).attributes
  }

  before do
    create(:domain, :default)
  end

  describe "logged" do
    before do
      login_user user
    end

    describe "POST create_or_update" do
      it "creates a new device" do
        expect {
          post :create_or_update, {device: valid_attributes}
        }.to change(Device, :count).by(1)
      end

      it "assigns a newly created device as @device" do
        post :create_or_update, {device: valid_attributes}
        expect(assigns(:device)).to be_a(Device)
        expect(assigns(:device)).to be_persisted
      end
    end

    context "update device" do
      before do
        create(:device, valid_attributes.merge(user_id: user.id))
      end

      describe "POST create_or_update" do
        it "creates a new device" do
          expect {
            post :create_or_update, {device: valid_attributes.merge(name: "new name")}
          }.not_to change(Device, :count)
        end

        it "assigns a newly created device as @device" do
          resp = post :create_or_update, {device: valid_attributes.merge(name: "new name")}
          expect(assigns(:device)).to be_a(Device)
          expect(assigns(:device)).to be_persisted
          expect(assigns(:device).name).to eql("new name")
        end
      end
    end

  end

end
