# == Schema Information
#
# Table name: post_views
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  post_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class PostView < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  validates_uniqueness_of :user_id, scope: :post_id
end
