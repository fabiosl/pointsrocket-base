class CommunityInviteSerializer < ActiveModel::Serializer
  attributes :id, :status, :created_at

  belongs_to :user

  class UserSerializer < ActiveModel::Serializer
    attributes :id, :name, :email, :avatar
  end
end
