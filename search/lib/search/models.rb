require 'search/act_as_searchable'

module Search
  module Models
    def act_as_searchable
      include Search::ActAsSearchable
      # has_one :search_item, as: :searchable
    end
  end
end
