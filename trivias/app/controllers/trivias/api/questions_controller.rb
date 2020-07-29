module Trivias
  class Api::QuestionsController < Trivias.parent_controller

    def random_question
      @play = Play.find(params['play_id'])
      @answered_questions_ids = @play.questions.pluck 'id'

      @question = Question.where.not(
        id: @answered_questions_ids).order('RANDOM()').first

      if not @question
        render nothing: true, status: :not_found
      end
    end

  end
end

