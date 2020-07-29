module MentionableContent
  extend ActiveSupport::Concern

  MENTION_REGEX = /<span (?:class=\"[\w\s-]*\") data-mention-user-id=\"(\d+)\">@(.+?)<\/span>/

  included do
    after_create :notify_mentioned_users
  end

  def linked_content
    auto_link_content = Rinku.auto_link(content, :urls, 'target=_blank')
    auto_link_content.gsub(MENTION_REGEX) do
      "<b><a href='/dashboard/usuarios/#{$1}'>@#{$2}</a></b>"
    end
  end

  def notify_mentioned_users
    mentioned_users.each do |mentioned_user|
      next if mentioned_user == user
      create_notification_for_mentionable_content('mention_user', mentioned_user)
      mail_user(mentioned_user)
    end
  end

  def mentioned_users
    users = []
    content_mentions_list.each do |mention|
      # mention[0] = user id / mention[1] = user name
      users << User.find(mention[0])
    end
    users.uniq { |u| u.id }
  end

  def create_notification_for_mentionable_content(action, recipient)
    Notification.create!(
      recipient: recipient,
      actor: user,
      action: action,
      notifiable: self
    )
  end

  def mail_user(recipient)
    domain = Domain.find_by(subdomain: Apartment::Tenant.current)
    MentionMailWorker.perform_async(domain.id, recipient.id, self.class, id)
  end

  def content_mentions_list
    content.scan(MENTION_REGEX)
  end
end
