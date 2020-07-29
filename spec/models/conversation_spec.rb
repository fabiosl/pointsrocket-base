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

require 'rails_helper'

RSpec.describe Conversation, type: :model do
  subject { build(:conversation) }

  it { should validate_uniqueness_of(:sender_id).scoped_to(:recipient_id) }
  it { should have_many(:messages) }


  it 'should have conversation between two users no matter who is the sender or recipient' do
    conversation = create(:conversation, sender_id: 1, recipient_id: 2)

    expect(Conversation.between(1, 2)).to eq([conversation])
    expect(Conversation.between(2, 1)).to eq([conversation])
  end

  it 'should return conversations with user' do
    user = create(:user)
    conversation_1 = create(:conversation, sender_id: user.id)
    conversation_2 = create(:conversation, recipient_id: user.id)

    expect(Conversation.with_user(user)).to eq([conversation_1, conversation_2])
  end
end
