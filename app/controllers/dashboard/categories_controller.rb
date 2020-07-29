class Dashboard::CategoriesController < DashboardController
  def show
    @category = Category.find(params['id'])
  end
end
