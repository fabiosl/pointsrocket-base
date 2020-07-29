class StepDecorator < Draper::Decorator
  delegate_all

  def video_source
    if /youtube/.match object.url
      return :youtube
    end

    if /vimeo/.match object.url
      return :vimeo
    end

    raise "Could not retrieve video_source for url #{object.url}"
  end

  def video_id
    case video_source
    when :youtube
      split = object.url.split('youtube.com/embed/')
      if split.length >= 2
        return split.last.split('?').first
      else
        raise "Could not get video_id for youtube url #{object.url}"
      end
    when :vimeo
      return "Ainda tem que parsear #{object.url}"
    end
  end

end
