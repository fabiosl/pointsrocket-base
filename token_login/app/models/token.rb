# == Schema Information
#
# Table name: tokens
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  key         :string(255)
#  valid_until :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

class Token < ActiveRecord::Base
  belongs_to :user

  def self.get_by_key key
    return nil if not key

    where(key: key).where('valid_until > ?', Time.now).first
  end

  def self.create_for args
    user = find_user args

    if user
      Token.create!(user: user, key: SecureRandom.hex, valid_until: 10.minutes.from_now)
    else
      nil
    end
  end

  def self.find_user args
    User.where(args).first
  end
end
