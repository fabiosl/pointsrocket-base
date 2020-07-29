# == Schema Information
#
# Table name: invites
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  token      :string(255)
#

FactoryGirl.define do
  factory :invite do
    email FFaker::Internet.email
    status "pending"
    token FFaker::HealthcareIpsum.characters
  end

end
