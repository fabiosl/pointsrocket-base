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

require 'rails_helper'

RSpec.describe PostView, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
