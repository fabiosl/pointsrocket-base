class CommentDecorator < Draper::Decorator
  delegate_all

  include Rails.application.routes.url_helpers

  def path
    result = case object.commentable_type
              when 'Challenge'
                challenge_path(object.commentable)
              when 'HashtagChallenge'
                hashtag_challenge_path(object.commentable)
              when 'Broadcast'
                broadcast_path(object.commentable)
              else
                "/dashboard/timeline?timelineable_type=#{object.commentable_type}&" \
                "timelineable_id=#{object.commentable_id}"
              end
    "#{result}#comment-id-#{object.id}"
  end

  def notification_action_str
    I18n.t("views.notifications.actions.commented_#{object.commentable_type.downcase}")
  end
end
