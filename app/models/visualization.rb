# == Schema Information
#
# Table name: visualizations
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  broadcast_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#  status       :string(255)
#

class Visualization < ActiveRecord::Base
  belongs_to :user
  belongs_to :broadcast

  act_as_timelineable only_relation: true, update_relations: [:campaign]
end
