# Manoel: tive que corrigir um bug do recipiente
# pra isso usei o serializer do rabl.

class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :created_at

  belongs_to :recipient

  has_many :messages
end
