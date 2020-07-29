FactoryGirl.define do
  factory :identity do
    provider "facebook"
    uid { FFaker::Lorem.characters }
    name { FFaker::Name.name }
    access_token { FFaker::Name.name }
  end
end
