class PostSerializer < ActiveModel::Serializer
  attributes :id, :content, :linked_content

  has_many :views
end
