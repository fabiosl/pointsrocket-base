# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text
#  parent_id        :integer
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#  commentable_id   :integer
#  commentable_type :string(255)
#

FactoryGirl.define do
  factory :comment do
    content "MyString"
    parent nil
    user
    # commentable
  end

end
