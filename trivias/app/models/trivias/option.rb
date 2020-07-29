# == Schema Information
#
# Table name: trivias_options
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  correct     :boolean
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

module Trivias
  class Option < ActiveRecord::Base
    belongs_to :question, inverse_of: :options

    scope :correct, -> { where(correct: true) }
  end
end
