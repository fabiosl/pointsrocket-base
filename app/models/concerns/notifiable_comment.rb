module NotifiableComment
  def notify_comment(notifiable, actor, action)
    notify_owner(notifiable, actor, action)

    # Notify users who comment post, but its owner
    notify_commentators(notifiable, actor, action)
  end

  def notify_owner(notifiable, actor, action)
    create_notification(user, actor, action, notifiable) if notify_owner?(notifiable)
  end

  def notify_owner?(notifiable)
    has_owner? && notifiable.user != user
  end

  def has_owner?
    return false unless self.respond_to? :user
    user.present?
  end

  def notify_commentators(notifiable, actor, action)
    notified_users_ids = []
    comments.each do |comment|
      next if !notify_commentator?(notifiable, comment) ||
              notified_users_ids.include?(comment.user.id)

      create_notification(comment.user, actor, action, notifiable)
      notified_users_ids.push(comment.user.id)
    end
  end

  def create_notification(recipient, actor, action, notifiable)
    Notification.create!(
      recipient: recipient,
      actor: actor,
      action: action,
      notifiable: notifiable
    )
  end

  def notify_commentator?(notifiable, comment)
    notifiable.user != comment.user &&
    !commentable_owner?(comment)
  end

  def commentable_owner?(comment)
    comment.user == user if has_owner?
  end
end
