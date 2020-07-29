class Dashboard::PostsController < DashboardController
  before_action :set_post, only: [:views, :update, :destroy]

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def views
    @post.views.build(user: current_user)

    if @post.save
      render json: { post_id: @post.id, viewed: true }
    else
      render json: { errors: @post.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def create
    authorize! :create_posts, current_domain
    post = Post.new(post_params)
    post.content = replace_post_images(post)

    if post.save
      post.notify #if can? :notify_users, current_domain
      flash[:success] = I18n.t('controllers.dashboard.posts.create.success')
    else
      flash[:danger] = I18n.t('controllers.dashboard.posts.create.error', messages: post.errors.full_messages.join(', '))
    end
    redirect_to root_path
  end

  def update
    authorize! :manage, @post

    @post.content = params[:post][:content]
    @post.content = replace_post_images(@post)

    if @post.save
      render json: @post
    else
      render json: I18n.t('controllers.dashboard.posts.update.error'),
             status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :manage, @post
    @post.destroy
    redirect_to timeline_path
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post)
          .permit(:content, :notify_users)
          .merge(user_id: current_user.id)
  end

  def check_domain_admin
    return if current_user.admin_domain?(current_domain)
    flash[:danger] = I18n.t('controllers.dashboard.posts.check_domain_admin.error')
    redirect_to root_path
  end

  def replace_post_images(post)
    uploader = Base64ImageUploader.new(PostImageUploader.new)
    converter = HtmlBase64ImageConverter.new(post.content, uploader)
    converter.replace_images(root_url.slice(0..-2))
  end
end
