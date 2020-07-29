class AddFromMailToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :from_mail, :string
  end
end
