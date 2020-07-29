module Trivias
  module ApplicationHelper

    def has_responded_trivia
    end

    def has_answered_question? user_trivia, question
      UserAnswer.where(
        user_trivia: user_trivia,
        question: question,
        correct: [true, false]
        ).any?
    end

    def has_answered_question_correct? user_trivia, question
      UserAnswer.where(
        user_trivia: user_trivia,
        question: question,
        correct: true
        ).any?
    end

    def has_answered_question_wrong? user_trivia, question
      UserAnswer.where(
        user_trivia: user_trivia,
        question: question,
        correct: false
        ).any?
    end

  end
end
