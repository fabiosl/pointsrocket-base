class Post < ActiveRecord::Base
  act_as_searchable

  def search_content
    self.title
  end

  def search_datetime
    self.created_at
  end
end
