# == Schema Information
#
# Table name: coin_gives
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class CoinGive < ActiveRecord::Base
  include NotifiableComment

  act_as_timelineable type: :admin
  belongs_to :user

  has_many :coin_users, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
end
