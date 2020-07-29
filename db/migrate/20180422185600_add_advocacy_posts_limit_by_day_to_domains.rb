class AddAdvocacyPostsLimitByDayToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :advocacy_posts_limit_by_day, :integer, default: 0
  end
end
