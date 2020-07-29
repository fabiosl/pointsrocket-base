attributes *[
  :admin, :name, :avatar,
  :admin_current_domain,
  :sum_points, :id, :lang, :locale
]

if locals[:unread_notifications_count]
  node :unread_notifications_count do |obj|
    obj.notifications.unread.count
  end
end

if locals[:full_data]
  attributes :facebook_page_name_to_monitor, :username, :timezone, :country, :email

  child :identities do
    attributes :id, :provider, :uid, :name, :access_token, :scopes, :avatar,
      :created_at

    node :social_url do |identity|
      identity.decorate.social_url
    end
  end
end
