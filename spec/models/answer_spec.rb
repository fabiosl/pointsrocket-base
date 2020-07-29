# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  content     :text
#  user_id     :integer
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  archive     :string(255)
#

require 'rails_helper'

RSpec.describe Answer, type: :model do

  describe 'validation' do
    [:content, :user, :question].each do |attribute|
      it "validates presence of #{attribute}" do
        attributes = {}
        attributes[attribute] = nil
        @answer = build(:answer, attributes)
        @answer.valid?
        expect(@answer.errors).to have_key(attribute)
      end
    end
  end


  describe "associations" do
    describe "votes" do
      it "retrieves votes" do
        voting_user = create(:user)
        answer = create(:answer)
        vote = create(:vote, voteable: answer, user: voting_user)

        expect(answer.votes).to match_array([vote])
      end
    end
  end
end
