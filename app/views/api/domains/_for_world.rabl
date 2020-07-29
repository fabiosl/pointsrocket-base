object @domain
attributes *[:id, :name, :description, :url, :default,
  :dashboard_image_down_file_name,
  :employee_advocacy_email_logo_image_file_name,
  :dashboard_menu_image_file_name, :dashboard_login_image_file_name,
  :dashboard_menu_image_contract_file_name, :employee_advocacy_enabled,
  :facebook_app_id, :twitter_app_id,
  :linkedin_app_id, :dashboard_enabled, :courses_enabled,
  :forum_enabled, :after_signin_path, :css, :is_points, :has_indication, :has_homepage,
  :layout, :instagram_app_id, :youtube_app_id,
  :css_text, :challenges_enabled, :hashtag_challenges_enabled, :broadcasts_enabled,
  :campaigns_enabled, :peer_recognition_enabled, :any_user_can_post, :login_providers,
  :pass_domains_select_and_log_here_directly, :only_invited, :from_mail,
  :challenge_localize_key, :social_network_permiteds,
  :weekly_user_coins, :peer_recognition_hashtags, :peer_recognition_hashtags_items, :score_disabled
]

node :dashboard_image_down_url do |obj|
  obj.dashboard_image_down.url :down if obj.dashboard_image_down.exists?
end

node :dashboard_menu_image_url do |obj|
  obj.dashboard_menu_image.url if obj.dashboard_menu_image.exists?
end

node :dashboard_login_image_url do |obj|
  obj.dashboard_login_image.url if obj.dashboard_login_image.exists?
end

node :dashboard_menu_image_contract_url do |obj|
  obj.dashboard_menu_image_contract.url if obj.dashboard_menu_image_contract.exists?
end

node :employee_advocacy_email_logo_image_url do |obj|
  obj.employee_advocacy_email_logo_image.url if obj.employee_advocacy_email_logo_image.exists?
end

child :domain_br_badge_events do
  extends "api/domain_br_badge_events/index"
end

child :how_to_point_items do
  extends "api/how_to_point_items/index"
end