class AddCssTextToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :css_text, :text
  end
end
