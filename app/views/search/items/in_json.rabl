object false

child(Search::ItemDecorator.decorate_collection(@items) => :items) do
  attributes :id, :searchable_type, :searchable_id

  node(:url) { |item| item.url }
  node(:formatted_title) { |item| item.formatted_title }
  node(:formatted_headline) { |item| item.formatted_headline }
  node(:formatted_content) { |item| item.formatted_content }
  node(:icon) { |item| item.icon }
  node(:thumb) { |item| item.thumb_url }
end
