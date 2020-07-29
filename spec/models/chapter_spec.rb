# == Schema Information
#
# Table name: chapters
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  course_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#  slug        :string(255)
#  position    :integer
#

require 'rails_helper'

RSpec.describe Chapter, type: :model do
  describe 'points' do
    subject {
      @chapter = create(:chapter)
      @video = create(:step, step_type: 'Vídeo', chapter: @chapter) # 20 ENV['DEFAULT_STEP_POINTS']
      @quiz_without_points_1 = create(:step, step_type: 'Quiz', chapter: @chapter) # 20 ENV['DEFAULT_STEP_QUESTION_POINTS']
      @quiz_without_points_2 = create(:step, step_type: 'Quiz', chapter: @chapter) # 20 ENV['DEFAULT_STEP_QUESTION_POINTS']
      @quiz_with_points = create(:step, step_type: 'Quiz', chapter: @chapter) # 50
      @quiz_with_points_question_1 = create(:step_question, step: @quiz_with_points, score: 50)
      @chapter.points
    }

    it "retrieves points" do
      is_expected.to eq(110)
    end
  end
end
