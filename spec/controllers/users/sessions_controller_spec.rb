# require 'rails_helper'

# RSpec.describe Users::SessionsController, :type => :controller do

#   controller do
#     def after_sign_in_path_for(resource)
#       super resource
#     end
#   end

#   before do
#     @request.env["devise.mapping"] = Devise.mappings[:user]
#   end

#   describe "POST create" do
#     context "when insert credit card" do
#       before do
#         @user = create(:user)
#         order = create(:order, user: @user)
#         payment = create(:payment, order: order)
#       end

#       it "redirects to dashboard" do
#         expect(controller.after_sign_in_path_for(@user)).to eq(dashboard_path)
#       end
#     end

#     context "when didn`t insert credit card info" do

#       before do
#         @user = create(:user)
#         post :create, { user: @user.attributes }
#       end

#       it "redirects to orders" do
#         expect(controller.after_sign_in_path_for(@user)).to eq(orders_path)
#       end

#       # before do
#       #   post :create, { user: parameters }
#       # end

#       # it "redirects to orders_path" do
#       #   user = create(:user)
#       #   expect(controller.after_sign_up_path_for(user)).to eq(orders_path)
#       # end
#     end

#     # context "when new user" do
#     #   it "should not redirect user to pay screen" do
#     #     login_user
#     #     get :index
#     #     expect(response).to be_success
#     #   end
#     # end

#     # context "when pass 7 days user" do
#     #   it "should redirect user to pay screen" do
#     #     login_user_expired
#     #     get :index
#     #     expect(response).to redirect_to(orders_path)
#     #   end
#     # end
#   end


# end
