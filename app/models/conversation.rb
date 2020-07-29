# == Schema Information
#
# Table name: conversations
#
#  id           :integer          not null, primary key
#  sender_id    :integer
#  recipient_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Conversation < ActiveRecord::Base
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  has_many :messages, dependent: :destroy

  validates_presence_of :sender_id, :recipient_id
  validates_uniqueness_of :sender_id, scope: :recipient_id

  scope :with_user, -> (user) { where("? IN (sender_id, recipient_id)", user.id) }

  scope :between, -> (sender_id, recipient_id) do
    where(
      "(conversations.sender_id = ? AND conversations.recipient_id = ?) OR 
      ((conversations.sender_id = ? AND conversations.recipient_id = ?))",
      sender_id, recipient_id, recipient_id, sender_id
    )
  end

  def self.find_or_create(params)
    conversation = between(params['sender_id'], params['recipient_id']).first
    
    conversation || create(params)
  end

  def ordered_messages
    messages.by_created_at
  end
end
