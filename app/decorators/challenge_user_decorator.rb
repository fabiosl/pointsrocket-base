class ChallengeUserDecorator < Draper::Decorator
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::AssetTagHelper

  delegate_all

  def file_content
    return image_tag(object.file.url) if object.has_image_file?
    return link_to(
      I18n.t('views.challenges.show.form.fields.file.title'),
      object.file.url,
      target: '_blank'
    ) if object.file.present?
  end
end
