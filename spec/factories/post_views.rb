# == Schema Information
#
# Table name: post_views
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  post_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :post_view do
    user nil
post nil
  end

end
