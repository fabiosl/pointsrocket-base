module ImageValidatable
  extend ActiveSupport::Concern

  included do
    validate :gif_file_size
  end

  def gif_file_size
    if image.content_type == 'image/gif' && image.size > 1.megabyte
      errors.add(:image, I18n.t('errors.messages.file_size'))
    end
  end
end