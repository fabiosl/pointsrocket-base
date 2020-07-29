# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  street     :string(255)
#  number     :integer
#  complement :string(255)
#  district   :string(255)
#  city       :string(255)
#  state      :string(255)
#  country    :string(255)
#  zipcode    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#


class Address < ActiveRecord::Base
  belongs_to :user, inverse_of: :addresses
  # validates_presence_of :street, :number, :district, :state, :country, :zipcode, :city
  validates_presence_of :country

  has_many :payments, inverse_of: :address

  before_create :put_default_values

  def put_default_values
    if not self.zipcode
      self.zipcode = '58340000'
    end
  end

  def moip_attributes
    attrs = ActiveSupport::HashWithIndifferentAccess.new(self.attributes)
    merge = {}
    if self.zipcode
      merge = {
        zipcode: self.zipcode.gsub('-', '')
      }
    end
    attrs.slice(:street, :number, :district, :state, :country, :city, :complement).merge(merge)
  end
end
