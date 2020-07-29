# == Schema Information
#
# Table name: block_users
#
#  id         :integer          not null, primary key
#  blocker_id :integer
#  blocked_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class BlockUser < ActiveRecord::Base
  validates_presence_of :blocker_id, :blocked_id
  validates :blocked_id, uniqueness: { scope: :blocker_id, message: "Blocker can only block Blocked once" }

  belongs_to :blocker, class_name: "User", inverse_of: :block_users
  belongs_to :blocked, class_name: "User"
end
