# == Schema Information
#
# Table name: trails
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  slug        :string(255)
#  hours       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  position    :integer
#  age_group   :string(255)
#  video_url   :string(255)
#  active      :boolean          default(TRUE)
#

require 'rails_helper'

RSpec.describe Trail, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
