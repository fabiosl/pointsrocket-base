# == Schema Information
#
# Table name: external_actions
#
#  id         :integer          not null, primary key
#  text       :text
#  created_at :datetime
#  updated_at :datetime
#  domain_id  :integer
#

FactoryGirl.define do
  factory :external_action do
    text "MyText"
  end

end
