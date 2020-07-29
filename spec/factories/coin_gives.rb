# == Schema Information
#
# Table name: coin_gives
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :coin_gife, :class => 'CoinGive' do
    user_id 1
content "MyText"
  end

end
