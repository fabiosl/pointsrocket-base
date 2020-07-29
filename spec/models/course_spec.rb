# == Schema Information
#
# Table name: courses
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  slug                :string(255)
#  comming_soon        :boolean          default(FALSE)
#  preview_url         :string(255)
#  active              :boolean          default(TRUE)
#  monitor_html        :text
#

require 'rails_helper'

RSpec.describe Course, type: :model do

  subject { create(:course) }

  it_behaves_like "taggable"

  describe 'points' do
    subject {
      @course = create(:course)
      @chapter = create(:chapter, course: @course)
      @video = create(:step, step_type: 'Vídeo', chapter: @chapter) # 20 ENV['DEFAULT_STEP_POINTS']
      @quiz_without_points_1 = create(:step, step_type: 'Quiz', chapter: @chapter) # 20 ENV['DEFAULT_STEP_QUESTION_POINTS']
      @quiz_without_points_2 = create(:step, step_type: 'Quiz', chapter: @chapter) # 20 ENV['DEFAULT_STEP_QUESTION_POINTS']
      @quiz_with_points = create(:step, step_type: 'Quiz', chapter: @chapter) # 50
      @quiz_with_points_question_1 = create(:step_question, step: @quiz_with_points, score: 50)
      @course.points
    }

    it "retrieves points" do
      is_expected.to eq(110)
    end
  end
end
