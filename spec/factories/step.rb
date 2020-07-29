
FactoryGirl.define do
  factory :step do
    name { FFaker::Name.name }
    description { FFaker::Lorem.sentence }
    chapter
    position 1
    step_type 'Vídeo'
  end
end
