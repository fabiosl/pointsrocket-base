# == Schema Information
#
# Table name: reservas
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  email            :string(255)
#  phone            :string(255)
#  curso_landing_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Reserva < ActiveRecord::Base
  validates :name, :email, :phone, presence: true
  validates :email, presence: true, email: true

  belongs_to :curso_landing, inverse_of: :reservas
end
