# == Schema Information
#
# Table name: trivias_questions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  trivia_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

module Trivias
  class Question < ActiveRecord::Base
    belongs_to :trivia, inverse_of: :questions
    has_many :options, inverse_of: :question, dependent: :destroy

    has_many :answers, inverse_of: :question
    has_many :plays, through: :answers

    accepts_nested_attributes_for :options, :allow_destroy => true
  end
end
