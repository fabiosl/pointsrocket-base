class AddPersonalShareToDomain < ActiveRecord::Migration
  def change
    add_column :domains, :share_in_personal, :boolean, default: true
    add_column :domains, :share_in_fanpage, :boolean, default: true
  end
end
