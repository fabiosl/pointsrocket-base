# == Schema Information
#
# Table name: category_links
#
#  id                :integer          not null, primary key
#  category_id       :integer
#  categoriable_id   :integer
#  categoriable_type :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

require 'rails_helper'

RSpec.describe CategoryLink, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
