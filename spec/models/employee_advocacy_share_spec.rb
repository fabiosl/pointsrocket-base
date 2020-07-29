# == Schema Information
#
# Table name: employee_advocacy_shares
#
#  id                        :integer          not null, primary key
#  employee_advocacy_post_id :integer
#  user_id                   :integer
#  social_network            :string(255)
#  user_content              :text
#  schedule_date             :datetime
#  shared_date               :datetime
#  token                     :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  social_json               :text
#  post_json                 :text
#  where_to_publish          :string(255)
#

require 'rails_helper'

RSpec.describe EmployeeAdvocacyShare, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
