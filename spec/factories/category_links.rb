# == Schema Information
#
# Table name: category_links
#
#  id                :integer          not null, primary key
#  category_id       :integer
#  categoriable_id   :integer
#  categoriable_type :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

FactoryGirl.define do
  factory :category_link do
    category nil
categoriable nil
  end

end
