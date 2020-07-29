# == Schema Information
#
# Table name: timeline_items
#
#  id                :integer          not null, primary key
#  timelineable_id   :integer
#  timelineable_type :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  item_type         :string(255)
#  visible           :boolean          default(TRUE)
#  pinned            :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe TimelineItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
