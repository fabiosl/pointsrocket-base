# == Schema Information
#
# Table name: campaigns
#
#  id                  :integer          not null, primary key
#  title               :string(255)
#  description         :text
#  start_date          :datetime
#  end_date            :datetime
#  slug                :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  image_file_name     :string(255)
#  image_content_type  :string(255)
#  image_file_size     :integer
#  image_updated_at    :datetime
#  redeem_points       :integer
#  max_redeems         :integer
#  withdrawable_points :integer          default(0)
#  subtitle            :string(255)      default("")
#

FactoryGirl.define do
  factory :campaign do
    title "MyString"
    description "MyString"
    start_date "2015-09-17 21:30:45"
    end_date "2015-09-17 21:30:45"
    slug "MyString"
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'photos', 'test.png'), 'image/png') }
  end

end
