# == Schema Information
#
# Table name: search_items
#
#  id              :integer          not null, primary key
#  searchable_id   :integer
#  searchable_type :string(255)
#  content         :text
#  created_at      :datetime
#  updated_at      :datetime
#

module Search
  class Item < ActiveRecord::Base
    belongs_to :searchable, polymorphic: true

    ransacker :content, type: :string do
      Arel.sql("unaccent(\"content\")")
    end
  end
end
