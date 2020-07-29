# == Schema Information
#
# Table name: franchisees
#
#  id         :integer          not null, primary key
#  token      :string(255)
#  logo       :string(255)
#  name       :string(255)
#  domain_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Franchisee < ActiveRecord::Base
  belongs_to :domain, inverse_of: :franchisees
  mount_uploader :logo, ImageUploader

  validates_presence_of :name, :token, :logo
  validates_uniqueness_of :token, scope: :domain_id

  acts_as_taggable
end
