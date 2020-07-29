module Trivias
  class Api::PlaysController < Trivias.parent_controller

    skip_before_action :verify_authenticity_token
    before_action :set_play, only: [:block]

    def block
      @play.stopped = true
      @play.stop_reason = params['reason']
      @play.save
      render nothing: true
    end

    private

      def set_play
        @play = Play.find params[:id]
      end

  end
end

