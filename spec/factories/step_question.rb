
FactoryGirl.define do
  factory :step_question do
    question { FFaker::Name.name }
    hint { FFaker::Name.name }
    step
  end
end
