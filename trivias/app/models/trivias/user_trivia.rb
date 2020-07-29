# == Schema Information
#
# Table name: trivias_user_trivia
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  trivia_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

module Trivias
  class UserTrivia < ActiveRecord::Base
    belongs_to :user, class_name: Trivias.user_class.to_s
    belongs_to :trivia, inverse_of: :user_trivias
    has_many :user_answers, inverse_of: :user_trivia

    accepts_nested_attributes_for :user_answers
  end
end
