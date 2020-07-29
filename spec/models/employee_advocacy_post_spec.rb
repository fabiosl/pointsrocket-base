# == Schema Information
#
# Table name: employee_advocacy_posts
#
#  id               :integer          not null, primary key
#  active           :boolean
#  facebook_points  :integer
#  twitter_points   :integer
#  linkedin_points  :integer
#  title            :string(10000)
#  content          :text
#  url              :string(255)
#  image            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  user_id          :integer
#  folder           :string(255)
#  valid_until      :datetime
#  instagram_points :integer          default(0)
#  video            :string(255)
#  download_points  :integer          default(0)
#

require 'rails_helper'

RSpec.describe EmployeeAdvocacyPost, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
