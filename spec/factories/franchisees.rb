# == Schema Information
#
# Table name: franchisees
#
#  id         :integer          not null, primary key
#  token      :string(255)
#  logo       :string(255)
#  name       :string(255)
#  domain_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :franchisee do
    token "MyString"
    logo { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'photos', 'test.png'), 'image/png') }
    name "MyString"
    domain nil
  end

end
