# == Schema Information
#
# Table name: post_images
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  image      :string(255)
#

require 'rails_helper'

RSpec.describe PostImage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
