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

require 'rails_helper'

RSpec.describe Oauth2Info, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
