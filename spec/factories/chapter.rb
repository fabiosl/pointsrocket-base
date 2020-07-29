
FactoryGirl.define do
  factory :chapter do
    name { FFaker::Name.name }
    description { FFaker::Lorem.sentence }
    course
  end
end
