# require 'rails_helper'

# RSpec.describe MoipHookController, :type => :controller do

#   describe "POST create" do
#     context "invoice" do
#       [:created, :status_updated].each do |event|
#         context "#{event}" do
#           it "calls Moip::WebhookFlow.MoipInvoice.update" do
#             params = {
#               moip_hook: {
#                 date: "09/08/2015 18:07:57",
#                 env: "sandbox",
#                 event: "invoice.#{event.to_s}",
#                 resource: {
#                   amount: 0,
#                   id: 6315904,
#                   status: {
#                     code: 3,
#                     description: "Pago"
#                   },
#                   subscription_code: "1439154476"
#                 }
#               }
#             }

#             # expect(Moip::WebhookFlow::MoipInvoice).to receive(:update).once()

#             post :create, params

#           end
#         end
#       end
#     end

#     # context "logged" do
#     #   let(:attributes) {
#     #     {
#     #       "user"=>{
#     #         "name"=>"Manoel Quirino Neto",
#     #         "email"=>"contato@manoelneto.com",
#     #         "cpf"=>"09220934029",
#     #         "phone"=>"(12) 312312312",
#     #         "birthdate"=>"27/02/1992",
#     #         "addresses_attributes"=>{
#     #           "0"=>{
#     #             "country"=>"BRA"
#     #           }
#     #         },
#     #         "credit_cards_attributes"=>{
#     #           "0"=>{
#     #             "holder_name"=>"Teste",
#     #             "number"=>"0000-0000-0000-0000",
#     #             "expiration"=>"12/17"
#     #           }
#     #         }
#     #       },
#     #     }
#     #   }

#     #   before do
#     #     login_unsubscribed_user
#     #   end

#     #   context "addresses" do
#     #     it "create an address" do
#     #       attributes.merge!(id: subject.current_user.id)
#     #       expect {
#     #         put :update, attributes
#     #       }.to change {
#     #         subject.current_user.addresses.count
#     #       }.by(1)
#     #     end
#     #   end
#     # end
#   end
# end
