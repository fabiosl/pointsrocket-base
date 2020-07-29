# == Schema Information
#
# Table name: domains
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
#

FactoryGirl.define do
  factory :domain do
    url FFaker::Internet.http_url
    name FFaker::Name.name
    subdomain FFaker::Internet.slug.gsub(".", '')

    trait :default do
      default true
    end
  end

end
