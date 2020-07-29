# == Schema Information
#
# Table name: curso_landings
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  description        :text
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  active             :boolean          default(FALSE)
#

class CursoLanding < ActiveRecord::Base
  has_attached_file :image, :styles => { :list => '368x276#' }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  has_many :reservas, inverse_of: :curso_landing, dependent: :destroy

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: [false, nil]) }
end
