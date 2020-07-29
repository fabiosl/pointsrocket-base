# == Schema Information
#
# Table name: posts
#
#  id           :integer          not null, primary key
#  content      :text
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#  notify_users :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Post, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
