# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  body            :text
#  conversation_id :integer
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#  read_at         :datetime
#

class Message < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :user

  validates_presence_of :body, :conversation, :user

  scope :unread, -> { where(read_at: nil) }

  scope :not_sent_by, -> (user) { where.not(user: user) }

  scope :by_created_at, -> { order(:created_at) }

   def created_at_str
    created_at.strftime("%d/%m/%Y #{I18n.t('views.general.time_at')} %Hh%M")
  end

  def recipient
    case user.id
    when conversation.sender.id then conversation.recipient
    when conversation.recipient.id then conversation.sender
    end
  end

  def notify_and_mail
    create_notification
    mail_recipient
  end

  def mail_recipient
    domain = Domain.find_by(subdomain: Apartment::Tenant.current)
    MessageMailWorker.perform_async(domain.id, recipient.id, id)
  end

  def create_notification
    Notification.create!(
      recipient: recipient,
      actor: user,
      action: 'create',
      notifiable: self
    )
  end
end
