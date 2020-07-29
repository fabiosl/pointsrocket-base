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

require 'rails_helper'

RSpec.describe Message, type: :model do
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:conversation) }
  it { should validate_presence_of(:user) }

  it 'should return who is the recipient of a message' do
    sender_user = create(:user)
    recipient_user = create(:user)
    conversation = create(
      :conversation,
      sender_id: sender_user.id,
      recipient_id: recipient_user.id
    )

    message_1 = create(:message, conversation: conversation, user: sender_user)
    message_2 = create(:message, conversation: conversation, user: recipient_user)

    expect(message_1.recipient).to eq(recipient_user)
    expect(message_2.recipient).to eq(sender_user)
  end

  it 'should return unread messages' do
    create(:message)

    expect(Message.unread.size).to eq(1)
  end

  it 'should return messages that were not sent by user' do
    user = create(:user)
    create(:message)

    expect(Message.not_sent_by(user).size).to eq(1)
  end
end
