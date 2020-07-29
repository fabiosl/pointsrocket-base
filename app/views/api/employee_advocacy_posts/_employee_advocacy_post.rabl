object @employee_advocacy_post

attributes *[
  :id, :title, :content,
  :url, :facebook_points, :twitter_points,
  :linkedin_points, :instagram_points, :download_points,
  :active, :created_at,
  :updated_at, :shared_by_user_ids, :folder,
  :valid_until, :expired, :expires_in_text
]

node :type do |item|
  if item.video.file.present?
    "video"
  else
    "photo"
  end
end

node :valid_until do |item|
  item.valid_until ? item.valid_until.strftime("%d/%m/%Y") : nil
end

node :image do |item|
  item.image.url
end

node :video do |item|
  item.video.url
end

node :image_small do |item|
  item.image.url(:thumb_big)
end

node :image_facebook do |item|
  item.image.url(:facebook)
end

child :user do |item|
  attributes :id, :name, :avatar, :avatar_timeline, :admin, :admin_current_domain
end

if respond_to? :current_user
  if current_user.present?
    node do |obj|
      shares = obj.employee_advocacy_shares.where(
        user: current_user).decorate
      {
        employee_advocacy_shares: partial(
          "api/employee_advocacy_shares/employee_advocacy_share", :object => shares)
      }
    end

    node :current_user_shared_on_facebook do |obj|
      obj.employee_advocacy_shares
         .where(user: current_user, social_network: 'facebook').any?
    end
    node :current_user_shared_on_download do |obj|
      obj.employee_advocacy_shares
         .where(user: current_user, social_network: 'download').any?
    end

    node :current_user_shared_on_twitter do |obj|
      obj.employee_advocacy_shares
         .where(user: current_user, social_network: 'twitter').any?
    end

    node :current_user_shared_on_linkedin do |obj|
      obj.employee_advocacy_shares
         .where(user: current_user, social_network: 'linkedin').any?
    end

    node :current_user_shared_on_instagram do |obj|
      obj.employee_advocacy_shares
         .where(user: current_user, social_network: 'instagram').any?
    end
  end

  node :people_shared_info do |item|
    info = item.people_shared_info(current_user)
    {
      first_two: partial(
        "api/employee_advocacy_shares/employee_advocacy_share", :object => info[:first_two]),
      resting_count: info[:resting_count],
      count: info[:count],
      count_label: I18n.t('views.employee_advocacy.users_shared_post', count: info[:count])
    }
  end
end
