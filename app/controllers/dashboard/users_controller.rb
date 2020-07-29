class Dashboard::UsersController < DashboardController
  before_action :set_user, only: [:show, :destroy]

  def index
    authorize! :manage_community, current_domain

    # membership only when subdomain as communities is true
    if ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'true'
      @user_query = User.domain(current_domain).ransack(params[:q])
    else
      @user_query = User.all.ransack(params[:q])
    end

    @users = @user_query.result
    @users = @users.paginate(page: params[:page], per_page: 20)
  end

  def show
    respond_to do |format|
      format.html { @user = @user.decorate }
      format.json { render json: @user }
    end
  end

  def members
    search = (params[:search] || "").slugify
    users = domain_users.where
                        .not(id: current_user.id)
                        .search(params[:search])
                        .order(name: :asc)
                        .sort_by {|u|
                          u.name.slugify.starts_with?(search) ? 0 : 1
                        }
                        

    render json: users, each_serializer: UserConversationSerializer
  end

  def badges
    authorize! :user_badges, current_user
    @user = User.find(params[:id])
    @badge_query = Badge.ransack(params[:q])
    @badges = @badge_query.result
  end

  def new
    @user = UserService.new_item({}, params)
  end

  def sign_in_previous_user
    user = User.find(session['previous_user_id'])
    sign_in(user) if user
    session.delete(:previous_user_id)
    redirect_to root_path
  end

  def destroy
    authorize! :manage_community, current_domain

    if ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'true'
      Membership.where(user: @user, domain: current_domain).destroy_all
    else
      @user.destroy
    end
    redirect_to users_path, notice: "Usuário removido da comunidade com sucesso."
  end

  def create
    @user = UserService.create(user_params, params)
    respond_to do |format|
      if @user.errors.empty?
        format.html { redirect_to users_path, notice: "Usuário criado com sucesso." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def avatar
    @user = UserService.find(params[:id])
    redirect_to @user.avatar.url(:s50x50)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def domain_users
    if ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'false'
      User.all
    else
      User.domain(current_domain)
    end
  end

  def user_params
    to_return = params.require(:user).permit(
      :name, :email, :password, :phone, :birthdate, :locale
    )

    to_return.merge!({
      tag_list: @domain.tag_list,
      created_in_dash: true,
      has_submited_payment_form: true
    })

    to_return
  end
end
