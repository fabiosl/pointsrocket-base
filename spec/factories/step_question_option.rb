
FactoryGirl.define do
  factory :step_question_option do
    step_question
    content { FFaker::Lorem.sentence }
  end
end
