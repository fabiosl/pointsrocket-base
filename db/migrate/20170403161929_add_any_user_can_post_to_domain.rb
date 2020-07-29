class AddAnyUserCanPostToDomain < ActiveRecord::Migration
  def change
    add_column :domains, :any_user_can_post, :boolean, default: false
  end
end
