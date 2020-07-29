class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :user, :created_at_str

  def user
    {
      id: object.user.id,
      name: object.user.name,
      avatar: object.user.avatar
    }
  end
end