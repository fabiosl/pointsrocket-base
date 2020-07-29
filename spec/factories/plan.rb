FactoryGirl.define do
  factory :plan do
    price 100
    amount 3990
    duration 12
    trial_days 7
    name "Anual"
    moip_code "anual"
  end
end
