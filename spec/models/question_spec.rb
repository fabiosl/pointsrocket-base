# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  user_id    :integer
#  step_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  archive    :string(255)
#

require 'rails_helper'

RSpec.describe Question, type: :model do

  describe 'validation' do
    [:title, :content, :user].each do |attribute|
      it "validates presence of #{attribute}" do
        attributes = {}
        attributes[attribute] = nil
        @question = build(:question, attributes)
        @question.valid?
        expect(@question.errors).to have_key(attribute)
      end
    end
  end

  describe "associations" do
    describe "votes" do
      it "retrieves votes" do
        voting_user = create(:user)
        question = create(:question)
        vote = create(:vote, voteable: question, user: voting_user)

        expect(question.votes).to match_array([vote])
      end
    end
  end
end
