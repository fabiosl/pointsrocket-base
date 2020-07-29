# == Schema Information
#
# Table name: categories
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  slug                 :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  position             :integer
#  logo                 :string(255)
#  change_to_franchisee :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Category, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
