# == Schema Information
#
# Table name: trivias_plays
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  questions   :text
#  created_at  :datetime
#  updated_at  :datetime
#  stopped     :boolean
#  stop_reason :string(255)
#

module Trivias
  class Play < ActiveRecord::Base
    belongs_to :user, class_name: Trivias.user_class.to_s

    has_many :answers, inverse_of: :play, dependent: :destroy
    has_many :questions, through: :answers

  end
end
