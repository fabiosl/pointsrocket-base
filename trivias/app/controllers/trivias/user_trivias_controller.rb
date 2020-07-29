module Trivias
  class UserTriviasController < Trivias.parent_controller
    before_action :set_user_trivia, only: [:update]
    helper :application

    def update
      if @user_trivia.update_attributes!(user_trivias_params)
        redirect_to :back, notice: "Respostas atualizadas com sucesso"
      else
        redirect_to :back, notice: "Erro ao tentar atualizar respostas"
      end
    end

    private

      def set_user_trivia
        @user_trivia = UserTrivia.find params[:id]
      end

      def user_trivias_params
        the_params = params.require(:user_trivia).permit(
          :id,
          user_answers_attributes: [
            :id,
            :option_id
          ]
        )
        the_params.merge!(id: params['id'])
      end
  end
end
