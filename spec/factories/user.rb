FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    name { FFaker::Name.name }
    phone "(83) 99602-3714"
    cpf "12312345567"
    # todo set brazilian locale

    # phone { "(83) 98828-1140" }
    # birthdate { 23.years.ago }
    birthdate { FFaker::Time.between(60.years.ago, 18.years.ago) }
    expires_at { Time.now }
    password "password"
    password_confirmation "password"
    plan
    locale 'en'
  end
end
