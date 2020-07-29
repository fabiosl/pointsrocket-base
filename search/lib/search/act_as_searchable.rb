module Search
  module ActAsSearchable
    extend ActiveSupport::Concern
    include ActionView::Helpers::SanitizeHelper

    def get_search_content model
      return model.name if model.class.name == 'User'
      txt = model.class.columns.select { |c|
        [:text, :string].include? c.type
      }.map { |c|
        model.send(c.name)
      }.join(' ')
      strip_tags txt
    end

    included do
      Search.register_model self

      has_one :search_item, as: :searchable, class_name: 'Search::Item'

      after_save :sync_search
      after_destroy :delete_search

      def sync_search
        search_item = Search::Item.where(searchable: self).first_or_create
        if self.respond_to? :search_content
          search_item.content = search_content
        else
          search_item.content = get_search_content self
        end

        if self.respond_to? :search_datetime
          search_item.datetime = search_datetime
        else
          search_item.datetime = self.created_at
        end

        if self.respond_to? :tags
          search_item.tags = self.tags
        end
        search_item.save!
      end

      def delete_search
        Search::Item.where(searchable: self).destroy_all
      end
    end
  end
end
