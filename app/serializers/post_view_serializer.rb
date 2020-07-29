class PostViewSerializer < ActiveModel::Serializer
  type 'view'

  belongs_to :user
  
  attributes :id

  attribute :posted_at do
    object.created_at.strftime(
      "%d/%m/%y #{I18n.t('views.general.time_at')} %H:%M"
    )
  end
  
end
