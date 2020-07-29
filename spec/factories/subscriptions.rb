# == Schema Information
#
# Table name: subscriptions
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  moip_code            :integer
#  status               :string(255)
#  remote_creation_date :datetime
#  amount               :integer
#  plan_id              :integer
#  next_invoice_date    :datetime
#  trial_start_time     :datetime
#  trial_end_time       :datetime
#  created_at           :datetime
#  updated_at           :datetime
#  not_renew            :boolean          default(FALSE)
#  active_until         :datetime
#  first_paid_day       :datetime
#  suspend_in           :datetime
#  suspended_in         :datetime
#  voucher_id           :integer
#

FactoryGirl.define do
  factory :subscription do
    user
    plan
    moip_code ""
    status "MyString"
    remote_creation_date "2015-08-03"
    amount ""
    next_invoice_date "2015-08-03"
    trial_start_time "2015-08-03"
    trial_end_time "2015-08-03"
  end

end
