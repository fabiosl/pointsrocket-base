# == Schema Information
#
# Table name: invoices
#
#  id                 :integer          not null, primary key
#  subscription_id    :integer
#  amount             :integer
#  creditation_date   :datetime
#  moip_code          :integer
#  items              :string(255)
#  status_code        :integer
#  subscription_code  :integer
#  occurrence         :integer
#  customer_code      :integer
#  customer_fullname  :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  status_description :string(255)
#

class Invoice < ActiveRecord::Base
  belongs_to :subscription, inverse_of: :invoices

  scope :real_paid, -> { where("amount > 0") }

  def update_from_moip params
    self.amount = params['amount']
    self.items = params['items'].to_json
    self.subscription_code = params['subscription_code']
    self.subscription = Subscription.where(moip_code: params['subscription_code']).first
    self.occurrence = params['occurrence']
    self.status_code = params['status']['code']
    self.status_description = params['status']['description']
    self.customer_code = params['customer']['code']
    self.customer_fullname = params['customer']['fullname']
    self.save
  end
end
