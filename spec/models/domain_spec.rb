# == Schema Information
#
# Table name: public.domains
#
#  id                                              :integer          not null, primary key
#  url                                             :string(255)
#  created_at                                      :datetime
#  updated_at                                      :datetime
#  name                                            :string(255)
#  has_indication                                  :boolean          default(FALSE)
#  is_points                                       :boolean          default(FALSE)
#  has_homepage                                    :boolean          default(FALSE)
#  default                                         :boolean          default(FALSE)
#  dashboard_image_down_file_name                  :string(255)
#  dashboard_image_down_content_type               :string(255)
#  dashboard_image_down_file_size                  :integer
#  dashboard_image_down_updated_at                 :datetime
#  dashboard_menu_image_file_name                  :string(255)
#  dashboard_menu_image_content_type               :string(255)
#  dashboard_menu_image_file_size                  :integer
#  dashboard_menu_image_updated_at                 :datetime
#  description                                     :text
#  layout                                          :string(255)
#  dashboard_login_image_file_name                 :string(255)
#  dashboard_login_image_content_type              :string(255)
#  dashboard_login_image_file_size                 :integer
#  dashboard_login_image_updated_at                :datetime
#  css                                             :string(255)
#  facebook_app_id                                 :string(255)
#  facebook_app_secret                             :string(255)
#  dashboard_menu_image_contract_file_name         :string(255)
#  dashboard_menu_image_contract_content_type      :string(255)
#  dashboard_menu_image_contract_file_size         :integer
#  dashboard_menu_image_contract_updated_at        :datetime
#  copyright                                       :string(255)
#  external_actions_rns                            :string(255)
#  employee_advocacy_enabled                       :boolean          default(FALSE)
#  after_signin_path                               :string(255)
#  twitter_app_id                                  :string(255)
#  twitter_app_secret                              :string(255)
#  linkedin_app_id                                 :string(255)
#  linkedin_app_secret                             :string(255)
#  dashboard_enabled                               :boolean          default(TRUE)
#  courses_enabled                                 :boolean          default(TRUE)
#  forum_enabled                                   :boolean          default(TRUE)
#  employee_advocacy_email_logo_image_file_name    :string(255)
#  employee_advocacy_email_logo_image_content_type :string(255)
#  employee_advocacy_email_logo_image_file_size    :integer
#  employee_advocacy_email_logo_image_updated_at   :datetime
#  youtube_app_id                                  :string(255)
#  youtube_app_secret                              :string(255)
#  instagram_app_id                                :string(255)
#  instagram_app_secret                            :string(255)
#  subdomain                                       :string(255)
#  css_text                                        :text
#  challenges_enabled                              :boolean          default(TRUE)
#  hashtag_challenges_enabled                      :boolean          default(TRUE)
#  broadcasts_enabled                              :boolean          default(TRUE)
#  campaigns_enabled                               :boolean          default(TRUE)
#  pass_domains_select_and_log_here_directly       :boolean          default(FALSE)
#  any_user_can_post                               :boolean          default(FALSE)
#  only_invited                                    :boolean          default(FALSE)
#  from_mail                                       :string(255)
#  challenge_localize_key                          :string(255)
#  login_terms_url                                 :string(255)
#  apn_key                                         :string(255)
#  social_network_permiteds                        :text
#  android_api_key                                 :string(255)
#  score_disabled                                  :boolean          default(FALSE)
#  login_providers                                 :string(255)
#  allow_content_report                            :boolean          default(FALSE)
#  weekly_user_coins                               :integer          default(0)
#  peer_recognition_enabled                        :boolean          default(FALSE)
#  peer_recognition_hashtags                       :text             default("")
#  advocacy_posts_limit_by_day                     :integer          default(0)
#  for_submission                                  :boolean          default(FALSE)
#  only_registered_hashtags                        :boolean          default(FALSE)
#  share_in_personal                               :boolean          default(TRUE)
#  share_in_fanpage                                :boolean          default(TRUE)
#

require 'rails_helper'

RSpec.describe Domain, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
