# == Schema Information
#
# Table name: hashtag_challenges
#
#  id                             :integer          not null, primary key
#  title                          :string(255)
#  date_start                     :datetime
#  date_end                       :datetime
#  points                         :integer
#  description                    :text
#  image                          :string(255)
#  slug                           :string(255)
#  badge_id                       :integer
#  hashtag                        :string(255)
#  terms                          :text
#  social_interactions_multiplier :float
#  created_at                     :datetime
#  updated_at                     :datetime
#

FactoryGirl.define do
  factory :hashtag_challenge do
    title "MyString"
date_start "2017-03-30 07:58:11"
date_end "2017-03-30 07:58:11"
points 1
description "MyText"
image "MyString"
slug "MyString"
badge nil
hashtag "MyString"
terms "MyText"
social_interactions_multiplier 1.5
  end

end
