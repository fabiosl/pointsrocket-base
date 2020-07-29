
FactoryGirl.define do
  factory :course do
    name { FFaker::Name.name }
    slug { FFaker::Name.name.parameterize }
    description { FFaker::Lorem.sentence }
    avatar { File.new("spec/fixtures/sample_file.jpg") }
  end
end
