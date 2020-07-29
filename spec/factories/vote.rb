
FactoryGirl.define do
  factory :vote do
    status 'upvote'
    voteable_type "Answer"
    voteable_id 1
    user
  end
end
