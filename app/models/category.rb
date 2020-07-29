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

class Category < ActiveRecord::Base

  # slug
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :category_links, inverse_of: :category

  mount_uploader :logo, CategoryLogoUploader

  acts_as_taggable

end
