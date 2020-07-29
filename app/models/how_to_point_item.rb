# == Schema Information
#
# Table name: how_to_point_items
#
#  id          :integer          not null, primary key
#  points      :integer
#  description :string(255)
#  section     :string(255)
#  domain_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class HowToPointItem < ActiveRecord::Base
  belongs_to :domain, inverse_of: :how_to_point_items
end
