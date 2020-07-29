class UserConversationSerializer < ActiveModel::Serializer
  attributes :id, :name, :avatar,
             :profile_url, :current_user_unread_messages_count,
             :has_current_user_unread_messages

  def profile_url
    "/dashboard/usuarios/#{object.id}"
  end

  def has_current_user_unread_messages
    current_user_unread_messages_count > 0  
  end

  def current_user_unread_messages_count
    current_user.count_unread_messages_sent_by(object)
  end

end
