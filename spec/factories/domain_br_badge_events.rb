# == Schema Information
#
# Table name: domain_br_badge_events
#
#  id         :integer          not null, primary key
#  domain_id  :integer
#  event      :string(255)
#  br_badge   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :domain_br_badge_event do
    domain
    event "MyString"
    br_badge "MyString"
  end

end
