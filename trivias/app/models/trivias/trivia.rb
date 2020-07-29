# == Schema Information
#
# Table name: trivias_trivia
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  slug           :string(255)
#  published_date :datetime
#  created_at     :datetime
#  updated_at     :datetime
#

module Trivias
  class Trivia < ActiveRecord::Base
    has_many :questions, inverse_of: :trivia, dependent: :destroy
    has_many :user_trivias, inverse_of: :trivia, dependent: :destroy

    accepts_nested_attributes_for :questions
  end
end
