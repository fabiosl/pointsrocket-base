require 'will_paginate/array'

module Search
  class ItemsController < parent_controller
    def index
      @search_query.sorts = 'datetime desc'

      @items = @search_query.result

      @items = @search_query.result.sort do |a, b|
        types_ordering.index(a.searchable_type) <=> types_ordering.index(b.searchable_type)
      end

      if self.respond_to? :process_search_query_result
        @items = self.process_search_query_result @items
      end

      @items = @items.paginate(
        page: params[:page],
        per_page: 10,
      )
    end

    def in_json
      index
    end

    private

    def types_ordering
      [
        'User',
        'Course',
        'Question',
        'HashtagChallenge',
        'Challenge',
        'Badge',
        'Chapter',
        'Step',
        'Answer',
        'EmployeeAdvocacyPost',
        'Post',
        'Campaign'
      ]
    end
  end
end
