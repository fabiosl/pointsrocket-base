class Search::ItemDecorator < Draper::Decorator
  delegate_all
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::DateHelper

  def icon
    if object.searchable.is_a? Question
      return 'ico-question2'
    end

    if object.searchable.is_a? Answer
      return 'ico-bubble-dots'
    end

    if object.searchable.is_a? Campaign
      return 'ico-gift22'
    end

    if object.searchable.is_a? Step
      return 'ico-graduation'
    end

    if object.searchable.is_a? Chapter
      return 'ico-graduation'
    end

    if object.searchable.is_a? Course
      return 'ico-graduation'
    end

    if object.searchable.is_a? Challenge
      return 'ico-lab'
    end

    if object.searchable.is_a? HashtagChallenge
      return 'ico-lab'
    end

    if object.searchable.is_a? Post
      return 'ico-file4'
    end

    if object.searchable.is_a? Broadcast
      return 'ico-camera6'
    end
  end

  def url
    if object.searchable.is_a? Answer
      return question_path(object.searchable.question)
    end

    if object.searchable.is_a? Broadcast
      return broadcast_path(object.searchable)
    end

    if object.searchable.is_a? Campaign
      return campaign_path(object.searchable)
    end

    if object.searchable.is_a? Course
      return course_path(object.searchable)
    end

    if object.searchable.is_a? Challenge
      return challenge_path(object.searchable)
    end
    
    if object.searchable.is_a? Chapter
      step = object.searchable.steps.order('position asc').first
      return course_chapter_step_path(step.chapter.course, step.chapter, step.position)
    end

    if object.searchable.is_a? EmployeeAdvocacyPost
      return employee_advocacy_path
    end

    if object.searchable.is_a? HashtagChallenge
      return hashtag_challenge_path(object.searchable)
    end

    if object.searchable.is_a? Post
      return dashboard_path
    end

    if object.searchable.is_a? Question
      return question_path(object.searchable)
    end
    
    if object.searchable.is_a? Step
      return course_chapter_step_path(object.searchable.chapter.course, object.searchable.chapter, object.searchable.position)
    end

    if object.searchable.is_a? User
      return user_path(object.searchable)
    end
  end

  def formatted_day
    object.datetime.strftime("%d")
  end

  def formatted_month
    object.datetime.strftime("%b")
  end

  def formatted_headline
    begin
      if object.searchable.is_a? Step
        return I18n.t "decorators.search.item_decorator.headline.course", {
          name: object.searchable.chapter.course.name
        }
      elsif object.searchable.is_a? Chapter
        return I18n.t "decorators.search.item_decorator.headline.course", {
          name: object.searchable.course.name
        }
      end

      if object.searchable.respond_to? :user
        return I18n.t "decorators.search.item_decorator.headline.user", {
          username: object.searchable.user.name,
          distance_of_time_in_words_to_now: distance_of_time_in_words_to_now(object.searchable.created_at)
        }
      else
        return I18n.t "decorators.search.item_decorator.headline.date", {
          distance_of_time_in_words_to_now: distance_of_time_in_words_to_now(object.searchable.created_at)
        }
      end
    rescue Exception => e
      ap e
    end
  end

  def formatted_title
    attribute = [:title, :name, :content, :description, :message].find do |attribute|
      object.searchable.respond_to? attribute and object.searchable.send(attribute).present?
    end

    if attribute.present?
      title = strip_tags object.searchable.send(attribute)
    else
      title = ''
    end

    return I18n.t "decorators.search.item_decorator.title.#{object.searchable.class.name}", {title: title}
  end

  def formatted_content
    attribute = [:content, :description, :message, :title, :name].find do |attribute|
      object.searchable.respond_to? attribute and object.searchable.send(attribute).present?
    end

    attribute.present? ? strip_tags(object.searchable.send(attribute)) : ''
  end

  def thumb_url
    if object.searchable.is_a? Broadcast
      return object.searchable.image_url(:thumb)
    elsif object.searchable.is_a? Step
      item_to_get_image = object.searchable.chapter.course
    elsif object.searchable.is_a? Chapter
      item_to_get_image = object.searchable.course
    else
      item_to_get_image = object.searchable
    end

    thumb_field = [:avatar, :picture, :image, :photo].find do |field|
      if item_to_get_image.respond_to? field
        item_to_get_image.send(field).is_a? CarrierWave::Uploader::Base or
          item_to_get_image.send(field).is_a? Paperclip::Attachment
      else
        false
      end
    end

    to_return = nil

    begin
      if thumb_field
        styles_permitteds = [:thumb_32, :thumb, :small, :thumb_big, :medium, :large]
        style_key = nil

        if item_to_get_image.send(thumb_field).is_a? Paperclip::Attachment
          style_key = styles_permitteds.find do |style|
            item_to_get_image.send(thumb_field).styles.keys.include? style
          end
        elsif item_to_get_image.send(thumb_field).is_a? CarrierWave::Uploader::Base
          style_key = styles_permitteds.find do |style|
            item_to_get_image.send(thumb_field).versions.keys.include? style
          end
        end

        if style_key
          to_return = item_to_get_image.send(thumb_field).url(style_key)
        else
          to_return = item_to_get_image.send(thumb_field).url
        end
      elsif item_to_get_image.respond_to? :user
        to_return = item_to_get_image.user.avatar.url(:dashboard_header)
      end
    rescue Exception => e
      ap e
    end

    to_return
  end

end
