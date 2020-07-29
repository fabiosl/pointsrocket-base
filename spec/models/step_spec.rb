# == Schema Information
#
# Table name: steps
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  url         :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  chapter_id  :integer
#  description :text
#  topic_id    :integer
#  position    :integer
#  step_type   :string(255)
#  free        :boolean          default(FALSE)
#  score       :integer          default(0)
#

require 'rails_helper'

RSpec.describe Step, type: :model do
  describe "points" do

    before do
      @video = create(:step, step_type: 'Vídeo') # 20 ENV['DEFAULT_STEP_POINTS']
      @quiz_without_points_1 = create(:step, step_type: 'Quiz') # 20 ENV['DEFAULT_STEP_QUESTION_POINTS']
      @quiz_without_points_2 = create(:step, step_type: 'Quiz') # 20 ENV['DEFAULT_STEP_QUESTION_POINTS']
      @quiz_with_points = create(:step, step_type: 'Quiz') # 50
      @quiz_with_points_question_1 = create(:step_question, step: @quiz_with_points, score: 50)
    end

    it "calculates points" do
      expect(Step.points).to eq(110)
    end

    it "calculates points for quizes" do
      expect(Step.quizes.points).to eq(90)
    end

    it "calculates points for videos" do
      expect(Step.videos.points).to eq(20)
    end

  end
end
