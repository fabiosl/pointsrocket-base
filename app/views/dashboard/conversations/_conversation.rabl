object @conversation

attributes :id, :created_at

node :recipient do |obj|
  the_recipient = current_user == obj.recipient ? obj.sender : obj.recipient

  {
    id: the_recipient.id,
    name: the_recipient.name,
    avatar: the_recipient.avatar,
    profile_url: "/dashboard/usuarios/#{the_recipient.id}"
  }
end

child :ordered_messages => :messages do
  attributes :id, :body, :created_at, :user, :created_at_str

  child :user do
    attributes :id, :name, :avatar
  end
end
