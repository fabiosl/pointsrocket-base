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

class CategoryLink < ActiveRecord::Base
  belongs_to :category, inverse_of: :category_links
  belongs_to :categoriable, polymorphic: true
end
