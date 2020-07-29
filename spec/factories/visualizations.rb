# == Schema Information
#
# Table name: visualizations
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  broadcast_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#  status       :string(255)
#

FactoryGirl.define do
  factory :visualization do
    user_id 1
broadcast_id 1
  end

end
