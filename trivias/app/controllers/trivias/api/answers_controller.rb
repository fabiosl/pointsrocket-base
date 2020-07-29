module Trivias
  class Api::AnswersController < Trivias.parent_controller

    skip_before_action :verify_authenticity_token

    def create
      @answer = Answer.create!(answer_params)
      render :show
    end

    private

      def answer_params
        params.require(:answer).permit(
          :question_id,
          :option_id,
          :play_id,
          :seconds_took
        )
      end

  end
end

