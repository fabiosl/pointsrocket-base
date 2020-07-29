class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :avatar, :profile_url

  def profile_url
    "/dashboard/usuarios/#{object.id}"
  end
end
