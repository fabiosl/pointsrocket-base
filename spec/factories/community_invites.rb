# == Schema Information
#
# Table name: community_invites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  domain_id  :integer
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :community_invite do
    user nil
domain nil
status "MyString"
  end

end
