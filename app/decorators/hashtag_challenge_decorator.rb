class HashtagChallengeDecorator < Draper::Decorator
  delegate_all
  
  include ActionView::Helpers::SanitizeHelper

  def truncate_description(chars_count)
    strip_tags(object.description).truncate(chars_count)
  end
end
