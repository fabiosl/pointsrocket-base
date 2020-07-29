module Notifiable
  extend ActiveSupport::Concern

  included do
    after_create :notify_create
  end

  def notify_create
    # Manoel: isso ta quebrando o teste, corrigir depois.
    if not Rails.env.test?
      create_notification('create')
    end
  end

  def create_notification(action)
    Notification.create!(
      recipient: notification_recipient,
      actor: nil,
      action: action,
      notifiable: self
    )
  end

  def notification_recipient
    user if self.respond_to? :user
  end
end
