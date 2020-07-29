class DomainDecorator < Draper::Decorator
  delegate_all
  
  def homepage_path
    if object.after_signin_path.present?
      return object.after_signin_path
    else
      return '/'
    end
  end

  def peer_recognition_hashtags_items
    if peer_recognition_hashtags
      peer_recognition_hashtags.split(/[#,\s]+/).sort_by(&:downcase)
    else
      []
    end
  end
end