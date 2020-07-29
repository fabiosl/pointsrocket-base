module Rabl
  class Engine
    include ActionView::Helpers::DateHelper
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::AssetTagHelper
  end
end


Rabl.configure do |config|
  config.include_json_root = false
  config.include_child_root = false
end
