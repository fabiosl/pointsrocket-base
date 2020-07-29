module Api
  class PostsController < Api::BaseController
    include PostsHelper
    include ControllerApiDomainHelper

    before_action :set_post, only: [:views, :view]

    def views
      render json: @post.views.order(created_at: :desc), adapter: :json
    end

    def view
      @post.views.build(user: current_user)

      if @post.save
        render json: { post: { id: @post.id, viewer_ids: @post.viewer_ids } }
      else
        render json: { errors: @post.errors.full_messages },
               status: :unprocessable_entity
      end
    end

    private

    def set_post
      @post = Post.find(params[:id])
    end
  end
end