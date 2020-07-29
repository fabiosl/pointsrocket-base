
FactoryGirl.define do
  factory :badge do
    name { FFaker::Name.name }
    badge_type "simple"
    badge_points 100
    avatar { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'photos', 'test.png'), 'image/png') }
  end
end
