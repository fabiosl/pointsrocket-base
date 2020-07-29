# == Schema Information
#
# Table name: public.oauth2_infos
#
#  id            :integer          not null, primary key
#  provider      :string(255)
#  uid           :string(255)
#  access_token  :string(255)
#  refresh_token :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Oauth2Info < ActiveRecord::Base
  validates_presence_of :uid, :provider, :refresh_token
  validates_uniqueness_of :uid, :scope => [:provider]

  scope :facebook, -> { where(provider: :facebook) }
  scope :twitter, -> { where(provider: :twitter) }
  scope :linkedin, -> { where(provider: :linkedin) }
  scope :instagram, -> { where(provider: :instagram) }
  scope :google_oauth2, -> { where(provider: :google_oauth2) }
  scope :youtube, -> { google_oauth2 }

end
