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

FactoryGirl.define do
  factory :timeline_item do
    timelineable nil
  end

end
