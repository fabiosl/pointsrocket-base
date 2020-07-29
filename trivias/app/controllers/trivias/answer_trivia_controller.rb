module Trivias
  class AnswerTriviaController < Trivias.parent_controller
    before_action :set_trivia
    helper ApplicationHelper

    def index
      @user_trivia = UserTrivia.where({
        user: current_user,
        trivia: @trivia
      }).first_or_create!

      render 'answer_trivia'
    end

    private

      def set_trivia
        @trivia = Trivia.find params[:id]
      end
  end
end

