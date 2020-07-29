module Api
  class TriviasQuestionsController < Api::BaseController
    before_filter :authenticate_user!
    skip_before_action :verify_authenticity_token
    before_action :set_domain

    def index
      @trivias_questions = resource_class.all
    end

    def create
    end

    # recieve a lot of Trivias::Question to sync
    def sync
      sync_params.each do |trivias_question_param|
        if trivias_question_param[:id].present?
          trivia_question = resource_class.find trivias_question_param[:id]
          if trivias_question_param[:_destroy] == true
            trivia_question.destroy
          else
            trivia_question.update_attributes(trivias_question_param.except(:_destroy))
          end
        else
          if trivias_question_param[:_destroy] != true
            trivia_question = resource_class.create!(trivias_question_param.except(:_destroy))
            trivia_question.tag_list = @domain.tag_list
            trivia_question.save
          end
        end
      end
      render nothing: true
    end

    def resource_class
      @resource_class ||= Trivias::Question
    end

    private

      def trivias_question_params
        params.require(:trivias_question).permit(
          :id,
          :name,
        )
      end

      def sync_params
        params.require(:trivias_questions).map { |trivias_question|
          trivias_question.permit(
            :id,
            :name,
            :_destroy,
            :options_attributes => [
              :id,
              :name,
              :correct,
              :_destroy
            ]
          )
        }
      end

      def query_params
        params.permit(:email)
      end

      def set_domain
        @domain = Domain.find params[:domain_id]
      end

  end
end
