require 'rails_helper'

RSpec.describe Users::RegistrationsController, :type => :controller do

  controller do
    def after_sign_up_path_for(resource)
      super resource
    end
  end

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "POST create" do
    context "with valid params" do
      let(:parameters) { build(:user).attributes }

      before do
        post :create, { user: parameters }
      end

      it "is success" do
        expect(response).to be_success
      end

      it "redirects to complete_registration_index_path" do
        user = create(:user)
        expect(controller.after_sign_up_path_for(user)).to eq(dashboard_path)
      end

      # it "redirects to complete_registration_index_path" do


      # it "saves the user" do
    end

    # context "when new user" do
    #   it "should not redirect user to pay screen" do
    #     login_user
    #     get :index
    #     expect(response).to be_success
    #   end
    # end

    # context "when pass 7 days user" do
    #   it "should redirect user to pay screen" do
    #     login_user_expired
    #     get :index
    #     expect(response).to redirect_to(complete_registration_index_path)
    #   end
    # end
  end


end
