module Api
  class CoursesController < Api::BaseController
    skip_before_action :verify_authenticity_token
    before_filter :authenticate_user!

    def index
      @courses = Course.all
    end

    def create
      super
      @course.save
      update_course_badge_domain
    end

    def update
      super
      update_course_badge_domain
    end

    private

    def update_course_badge_domain
      if @course.finish_badge_id.present?
        badge = Badge.find @course.finish_badge_id
        badge.tag_list = @course.tag_list
        badge.save
      end
    end

    # def get_resource_errors
    #   {
    #     course: {
    #       errors: get_resource.errors.to_hash,
    #       chapters: get_resource.chapters.map { |chapter|
    #         {
    #           errors: chapter.errors.to_hash,
    #           steps: chapter.steps.map { |step|
    #             {
    #               errors: step.errors.to_hash,
    #               archives: step.archives.map { |archive|
    #                 {
    #                   errors: archive.errors.to_hash,
    #                 }
    #               },
    #               step_questions: step.step_questions.map { |step_question|
    #                 {
    #                   errors: step_question.errors.to_hash,
    #                   step_question_options: step_question.step_question_options.map { |step_question_option|
    #                     {
    #                       errors: step_question_option.errors.to_hash,
    #                     }
    #                   }
    #                 }
    #               }
    #             }
    #           }
    #         }
    #       }
    #     }
    #   }
    # end

    def course_params
      the_params = params.require(:course).permit(
        :id,
        :name,
        :description,
        :slug,
        :avatar,
        :finish_badge_image,
        :finish_badge_points,
        :delete_finish_badge_points,
        :finish_badge_id,
        :preview_url,
        :active,
        :monitor_html,
        :chapters_attributes => [
          :id,
          :name,
          :description,
          :position,
          :_destroy,
          :steps_attributes => [
            :id,
            :name,
            :description,
            :step_type,
            :score,
            :url,
            :position,
            :_destroy,
            :archives_attributes => [
              :id,
              :archive,
              :_destroy
            ],
            :step_questions_attributes => [
              :id,
              :hint,
              :position,
              :question,
              :score,
              :_destroy,
              :step_question_options_attributes => [
                :id,
                :content,
                :correct,
                :_destroy,
              ]
            ]
          ]
        ]
      )

      the_params
    end

    def query_params
      params.permit(:email)
    end
  end
end
