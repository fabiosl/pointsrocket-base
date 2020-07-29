require 'rails_helper'

RSpec.describe CompleteRegistrationController, :type => :controller do

  describe "PATCH payment" do
    context "unlogged" do
      it "redirects to users sign up" do
        patch :payment, user: {}
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "logged" do
      let(:attributes) {
        {
          "user"=>{
            "name"=>"Manoel Quirino Neto",
            "email"=>"contato@manoelneto.com",
            "cpf"=>"09220934029",
            "phone"=>"(12) 312312312",
            "birthdate"=>"27/02/1992",
            "terms_agree"=>"1",
            "addresses_attributes"=>{
              "0"=>{
                "country"=>"BRA"
              }
            },
            "credit_cards_attributes"=>{
              "0"=>{
                "holder_name"=>"Teste",
                "number"=>"4716-3177-4088-9113",
                "expiration"=>"12/17"
              }
            }
          },
        }
      }

      before do
        login_unsubscribed_user
      end

      it "redirects to success" do
        patch :payment, attributes
        expect(request).to redirect_to(success_complete_registration_index_path)
      end

      context "addresses" do
        it "create an address" do
          attributes
          expect {
            patch :payment, attributes
          }.to change {
            subject.current_user.addresses.count
          }.by(1)
        end
      end
    end
  end
end
