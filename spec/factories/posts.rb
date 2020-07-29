# == Schema Information
#
# Table name: posts
#
#  id           :integer          not null, primary key
#  content      :text
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#  notify_users :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :post do
    content "MyText"
    user nil
  end
end
