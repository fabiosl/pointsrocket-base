module Api
  class CommentsController < Api::BaseController
    include CommentsHelper

    before_filter :authenticate_user!
    skip_before_action :verify_authenticity_token

    def index
      if not params[:commentable_id].present? and not params[:commentable_type].present?
        render json: {error: "You must pass commentable_id and commentable_type"}, status: :unprocessable_entity
        return
      end

      @comments = get_comments.page(params[:page] || 1)

      # if params["paging_key"].present?
      #   @comments = @comments.where("id < ?", params["paging_key"])
      # end

      # @comments = @comments.order("created_at desc").limit(1)
      # @last_comment = @comments.last
      set_response_headers
    end

    def create
      authorize! :create, Comment
      super
    end

    def update
      authorize! :update, get_resource
      super
    end

    def destroy
      authorize! :destroy, get_resource
      super
    end

    private

    def get_comments
      resource_class.where(
        commentable_type: params[:commentable_type],
        commentable_id: params[:commentable_id]
      ).order(created_at: :desc)
    end

    def get_hast_next_item
      if @last_comment
        get_comments.where(
          "id < ?", @last_comment.id.to_s).order("created_at desc").any?
      else
        false
      end
    end

    def set_response_headers
      response.headers['HAS-NEXT-PAGE'] = (!!@comments.next_page).to_s
      if @last_comment
        # setting has next interactions
        response.headers['HAS-NEXT-ITEM'] = get_hast_next_item().to_s

        # setting paging key
        response.headers['PAGGING_KEY'] = @last_comment.id.to_s
      end
    end

    def comment_params
      the_params = params.require(:"#{self.controller_name.singularize}")
                         .permit(@@permitted_params)
      the_params.merge!(user: current_user)
      the_params
    end

    def notify_users(comment, action)
      comment.notify(action)
    end

    def query_params
      params.permit(:commentable_id, :commentable_type)
    end
  end
end
