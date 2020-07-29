# == Schema Information
#
# Table name: credit_cards
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  holder_name           :string(255)
#  expiration            :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  flag                  :string(255)
#  last_digits           :string(255)
#  encrypted_number      :string(255)
#  encrypted_number_salt :string(255)
#  encrypted_number_iv   :string(255)
#

class CreditCardExpirationTimeValidator < ActiveModel::Validator
  def validate(record)
    if record.expiration.present?
      expiration_date = Date.strptime(record.expiration, "%m/%y")
      if expiration_date < Time.now
        record.errors[:base] << "Cartão de Crédito vencido"
      end
    end
  end
end

class CreditCard < ActiveRecord::Base
  belongs_to :user, inverse_of: :addresses

  validates_presence_of :user, :number, :holder_name, :expiration
  validates :number, length: { is: 19 }
  validates_format_of :expiration, with: /\d{2}\/\d{2}/
  validates_with CreditCardExpirationTimeValidator

  attr_encrypted :number, key: ENV['CREDIT_CARD_NUMBER_KEY'], mode: :per_attribute_iv_and_salt

  before_create :set_flag
  before_create :set_last_digits

  def set_last_digits
    self.last_digits = self.number.split('-')[-1]
  end

  def set_flag
    only_numbers = self.number.gsub('-', '')

    ['636368', '438935' '504175' '451416' '509048' '509067' '509049' '509069' '509050' '509074' '509068' '509040' '509045' '509051' '509046' '509066' '509047' '509042' '509052' '509043' '509064' '509040' '36297' '5067' '4576' '4011'].each do |num|
      if only_numbers.start_with? num
        self.flag = 'elo'
      end
    end

    ['301', '305', '36', '38'].each do |num|
      if only_numbers.start_with? num
        self.flag = 'dinners'
      end
    end

    ['34', '37'].each do |num|
      if only_numbers.start_with? num
        self.flag = 'amex'
      end
    end

    ['6011', '622', '64', '65'].each do |num|
      if only_numbers.start_with? num
        self.flag = 'discover'
      end
    end

    ['50'].each do |num|
      if only_numbers.start_with? num
        self.flag = 'aura'
      end
    end

    ['35'].each do |num|
      if only_numbers.start_with? num
        self.flag = 'jcb'
      end
    end

    ['38', '36'].each do |num|
      if only_numbers.start_with? num
        self.flag = 'hipercard'
      end
    end

    if only_numbers[0] == '4'
      self.flag = 'visa'
    end

    if only_numbers[0] == '5'
      self.flag = 'mastercard'
    end
  end

  def moip_attributes
    {
      number: self.number.gsub('-', ''),
      holder_name: self.holder_name,
      expiration_month: self.expiration.split('/')[0],
      expiration_year: self.expiration.split('/')[1]
    }
  end
end
