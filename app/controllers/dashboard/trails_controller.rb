class Dashboard::TrailsController < DashboardController
  before_action :set_categories
  before_action :set_category

  def index
    @trails = Trail.active

    if @category
      @trails = @trails.joins(:category_links).where({category_links: {category_id: @category.id}}).uniq
    end
  end

  private

    def set_categories
      @categories = Category.joins(:category_links).where({category_links: {categoriable_type: "Trail"}}).uniq
    end

    def set_category
      if params[:category_id].present?
        @category = @categories.find params[:category_id]
      end
    end
end
