module Trivias
  class TriviasController < Trivias.parent_controller
    before_action :set_current_play

    def index
      @trivias = Trivia.all
    end

    def make_trivia
      if @play.stopped
        redirect_to trivias_path, notice: "Você só pode responder amanhã"
      end
    end

    private

      def set_current_play
        @play = Play.where(user: current_user).where("created_at >= ?", Time.zone.now.beginning_of_day).first

        if not @play
          @play = Play.create!(user: current_user)
        end
      end
  end
end

