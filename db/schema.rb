# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20191002124851) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "addresses", force: true do |t|
    t.string   "street"
    t.integer  "number"
    t.string   "complement"
    t.string   "district"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zipcode"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "answers", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "archive"
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "archives", force: true do |t|
    t.string   "name"
    t.string   "archive"
    t.integer  "archiveable_id"
    t.string   "archiveable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets", force: true do |t|
    t.string   "storage_uid"
    t.string   "storage_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "storage_width"
    t.integer  "storage_height"
    t.float    "storage_aspect_ratio"
    t.integer  "storage_depth"
    t.string   "storage_format"
    t.string   "storage_mime_type"
    t.string   "storage_size"
  end

  create_table "badge_goals", force: true do |t|
    t.integer  "badge_id"
    t.integer  "goal_id"
    t.integer  "repetition"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "badge_goals", ["badge_id"], name: "index_badge_goals_on_badge_id", using: :btree
  add_index "badge_goals", ["goal_id"], name: "index_badge_goals_on_goal_id", using: :btree

  create_table "badge_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "badge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",   default: 1
  end

  create_table "badges", force: true do |t|
    t.integer  "badgeable_id"
    t.string   "badgeable_type"
    t.string   "name"
    t.string   "slug"
    t.integer  "badge_points"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "category"
    t.string   "hint"
    t.string   "badge_type"
  end

  add_index "badges", ["badgeable_id", "badgeable_type"], name: "index_badges_on_badgeable_id_and_badgeable_type", using: :btree

  create_table "block_users", force: true do |t|
    t.integer  "blocker_id"
    t.integer  "blocked_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "block_users", ["blocked_id"], name: "index_block_users_on_blocked_id", using: :btree
  add_index "block_users", ["blocker_id"], name: "index_block_users_on_blocker_id", using: :btree

  create_table "broadcasts", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "schedule_time"
    t.text     "description"
    t.integer  "badge_id"
    t.integer  "points"
    t.string   "slug"
  end

  add_index "broadcasts", ["badge_id"], name: "index_broadcasts_on_badge_id", using: :btree
  add_index "broadcasts", ["slug"], name: "index_broadcasts_on_slug", unique: true, using: :btree

  create_table "campaign_badges", force: true do |t|
    t.integer  "campaign_id"
    t.integer  "badge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  add_index "campaign_badges", ["badge_id"], name: "index_campaign_badges_on_badge_id", using: :btree
  add_index "campaign_badges", ["campaign_id"], name: "index_campaign_badges_on_campaign_id", using: :btree

  create_table "campaign_users", force: true do |t|
    t.integer  "campaign_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "campaign_users", ["campaign_id"], name: "index_campaign_users_on_campaign_id", using: :btree
  add_index "campaign_users", ["user_id"], name: "index_campaign_users_on_user_id", using: :btree

  create_table "campaigns", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "redeem_points"
    t.integer  "max_redeems"
    t.integer  "withdrawable_points", default: 0
    t.string   "subtitle",            default: ""
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.string   "logo"
    t.boolean  "change_to_franchisee", default: false
  end

  create_table "category_links", force: true do |t|
    t.integer  "category_id"
    t.integer  "categoriable_id"
    t.string   "categoriable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "category_links", ["categoriable_id", "categoriable_type"], name: "index_category_links_on_categoriable_id_and_categoriable_type", using: :btree
  add_index "category_links", ["category_id"], name: "index_category_links_on_category_id", using: :btree

  create_table "challenge_users", force: true do |t|
    t.integer  "challenge_id"
    t.integer  "user_id"
    t.string   "status"
    t.text     "feedback"
    t.string   "url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "json"
    t.string   "social_id"
    t.string   "file"
  end

  add_index "challenge_users", ["challenge_id"], name: "index_challenge_users_on_challenge_id", using: :btree
  add_index "challenge_users", ["user_id"], name: "index_challenge_users_on_user_id", using: :btree

  create_table "challenges", force: true do |t|
    t.string   "title"
    t.datetime "date_start"
    t.datetime "date_end"
    t.integer  "points"
    t.text     "description"
    t.string   "image"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "badge_id"
    t.text     "terms"
    t.string   "privacy",        default: "all"
    t.text     "recommendation"
  end

  add_index "challenges", ["badge_id"], name: "index_challenges_on_badge_id", using: :btree

  create_table "chapters", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "position"
  end

  create_table "coin_gives", force: true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coin_users", force: true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "points",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content"
    t.integer  "coin_give_id"
    t.text     "hashtags",     default: [], array: true
  end

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "parent_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "commentable_id"
    t.string   "commentable_type"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["parent_id"], name: "index_comments_on_parent_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "community_invites", force: true do |t|
    t.integer  "user_id"
    t.integer  "domain_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "community_invites", ["domain_id"], name: "index_community_invites_on_domain_id", using: :btree
  add_index "community_invites", ["user_id"], name: "index_community_invites_on_user_id", using: :btree

  create_table "complete_account_question_option_users", force: true do |t|
    t.integer  "complete_account_question_option_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "complete_account_question_option_users", ["complete_account_question_option_id"], name: "index_caqo_on_caqo_id", using: :btree
  add_index "complete_account_question_option_users", ["user_id"], name: "index_user_on_caqo_id", using: :btree

  create_table "complete_account_question_options", force: true do |t|
    t.integer  "complete_account_question_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "complete_account_question_options", ["complete_account_question_id"], name: "index_caqo_on_complete_account_question_id", using: :btree

  create_table "complete_account_questions", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversations", force: true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_trails", force: true do |t|
    t.integer  "course_id"
    t.integer  "trail_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_trails", ["course_id"], name: "index_course_trails_on_course_id", using: :btree
  add_index "course_trails", ["trail_id"], name: "index_course_trails_on_trail_id", using: :btree

  create_table "courses", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "slug"
    t.boolean  "comming_soon",        default: false
    t.string   "preview_url"
    t.boolean  "active",              default: true
    t.text     "monitor_html"
  end

  create_table "credit_cards", force: true do |t|
    t.integer  "user_id"
    t.string   "holder_name"
    t.string   "expiration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "flag"
    t.string   "last_digits"
    t.string   "encrypted_number"
    t.string   "encrypted_number_salt"
    t.string   "encrypted_number_iv"
  end

  add_index "credit_cards", ["user_id"], name: "index_credit_cards_on_user_id", using: :btree

  create_table "curso_landings", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "active",             default: false
  end

  create_table "devices", force: true do |t|
    t.integer  "user_id"
    t.string   "device_type"
    t.string   "push_notification_token"
    t.string   "device_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "push_notification_active", default: true
    t.string   "name"
  end

  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "domain_br_badge_events", force: true do |t|
    t.integer  "domain_id"
    t.string   "event"
    t.string   "br_badge"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "domain_br_badge_events", ["domain_id"], name: "index_domain_br_badge_events_on_domain_id", using: :btree

  create_table "domains", force: true do |t|
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "has_indication",                                  default: false
    t.boolean  "is_points",                                       default: false
    t.boolean  "has_homepage",                                    default: false
    t.boolean  "default",                                         default: false
    t.string   "dashboard_image_down_file_name"
    t.string   "dashboard_image_down_content_type"
    t.integer  "dashboard_image_down_file_size"
    t.datetime "dashboard_image_down_updated_at"
    t.string   "dashboard_menu_image_file_name"
    t.string   "dashboard_menu_image_content_type"
    t.integer  "dashboard_menu_image_file_size"
    t.datetime "dashboard_menu_image_updated_at"
    t.text     "description"
    t.string   "layout"
    t.string   "dashboard_login_image_file_name"
    t.string   "dashboard_login_image_content_type"
    t.integer  "dashboard_login_image_file_size"
    t.datetime "dashboard_login_image_updated_at"
    t.string   "css"
    t.string   "facebook_app_id"
    t.string   "facebook_app_secret"
    t.string   "dashboard_menu_image_contract_file_name"
    t.string   "dashboard_menu_image_contract_content_type"
    t.integer  "dashboard_menu_image_contract_file_size"
    t.datetime "dashboard_menu_image_contract_updated_at"
    t.string   "copyright"
    t.string   "external_actions_rns"
    t.boolean  "employee_advocacy_enabled",                       default: false
    t.string   "after_signin_path"
    t.string   "twitter_app_id"
    t.string   "twitter_app_secret"
    t.string   "linkedin_app_id"
    t.string   "linkedin_app_secret"
    t.boolean  "dashboard_enabled",                               default: true
    t.boolean  "courses_enabled",                                 default: true
    t.boolean  "forum_enabled",                                   default: true
    t.string   "employee_advocacy_email_logo_image_file_name"
    t.string   "employee_advocacy_email_logo_image_content_type"
    t.integer  "employee_advocacy_email_logo_image_file_size"
    t.datetime "employee_advocacy_email_logo_image_updated_at"
    t.string   "youtube_app_id"
    t.string   "youtube_app_secret"
    t.string   "instagram_app_id"
    t.string   "instagram_app_secret"
    t.string   "subdomain"
    t.text     "css_text"
    t.boolean  "challenges_enabled",                              default: true
    t.boolean  "hashtag_challenges_enabled",                      default: true
    t.boolean  "broadcasts_enabled",                              default: true
    t.boolean  "campaigns_enabled",                               default: true
    t.boolean  "pass_domains_select_and_log_here_directly",       default: false
    t.boolean  "any_user_can_post",                               default: false
    t.boolean  "only_invited",                                    default: false
    t.string   "from_mail"
    t.string   "challenge_localize_key"
    t.string   "login_terms_url"
    t.string   "apn_key"
    t.text     "social_network_permiteds"
    t.string   "android_api_key"
    t.boolean  "score_disabled",                                  default: false
    t.string   "login_providers"
    t.boolean  "allow_content_report",                            default: false
    t.integer  "weekly_user_coins",                               default: 0
    t.boolean  "peer_recognition_enabled",                        default: false
    t.text     "peer_recognition_hashtags",                       default: ""
    t.integer  "advocacy_posts_limit_by_day",                     default: 0
    t.boolean  "for_submission",                                  default: false
    t.boolean  "only_registered_hashtags",                        default: false
    t.boolean  "share_in_personal",                               default: true
    t.boolean  "share_in_fanpage",                                default: true
  end

  create_table "employee_advocacy_posts", force: true do |t|
    t.boolean  "active"
    t.integer  "facebook_points"
    t.integer  "twitter_points"
    t.integer  "linkedin_points"
    t.string   "title",            limit: 10000
    t.text     "content"
    t.string   "url"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "folder"
    t.datetime "valid_until"
    t.integer  "instagram_points",               default: 0
    t.string   "video"
    t.integer  "download_points",                default: 0
  end

  add_index "employee_advocacy_posts", ["user_id"], name: "index_employee_advocacy_posts_on_user_id", using: :btree

  create_table "employee_advocacy_shares", force: true do |t|
    t.integer  "employee_advocacy_post_id"
    t.integer  "user_id"
    t.string   "social_network"
    t.text     "user_content"
    t.datetime "schedule_date"
    t.datetime "shared_date"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "social_json"
    t.text     "post_json"
    t.string   "where_to_publish"
  end

  add_index "employee_advocacy_shares", ["employee_advocacy_post_id"], name: "index_employee_advocacy_shares_on_employee_advocacy_post_id", using: :btree
  add_index "employee_advocacy_shares", ["user_id"], name: "index_employee_advocacy_shares_on_user_id", using: :btree

  create_table "employee_advocacy_visits", force: true do |t|
    t.integer  "employee_advocacy_share_id"
    t.boolean  "new_visit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employee_advocacy_visits", ["employee_advocacy_share_id"], name: "index_employee_advocacy_visits_on_employee_advocacy_share_id", using: :btree
  add_index "employee_advocacy_visits", ["new_visit"], name: "index_employee_advocacy_visits_on_new_visit", using: :btree

  create_table "external_actions", force: true do |t|
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "domain_id"
  end

  add_index "external_actions", ["domain_id"], name: "index_external_actions_on_domain_id", using: :btree

  create_table "franchisees", force: true do |t|
    t.string   "token"
    t.string   "logo"
    t.string   "name"
    t.integer  "domain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "franchisees", ["domain_id"], name: "index_franchisees_on_domain_id", using: :btree

  create_table "goals", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "graduations", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "graduations", ["course_id"], name: "index_graduations_on_course_id", using: :btree
  add_index "graduations", ["user_id"], name: "index_graduations_on_user_id", using: :btree

  create_table "hashtag_challenge_users", force: true do |t|
    t.integer  "hashtag_challenge_id"
    t.string   "status"
    t.string   "url"
    t.text     "json"
    t.string   "social_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.text     "feedback"
  end

  add_index "hashtag_challenge_users", ["hashtag_challenge_id"], name: "index_hashtag_challenge_users_on_hashtag_challenge_id", using: :btree
  add_index "hashtag_challenge_users", ["user_id"], name: "index_hashtag_challenge_users_on_user_id", using: :btree

  create_table "hashtag_challenges", force: true do |t|
    t.string   "title"
    t.datetime "date_start"
    t.datetime "date_end"
    t.integer  "points"
    t.text     "description"
    t.string   "image"
    t.string   "slug"
    t.integer  "badge_id"
    t.string   "hashtag"
    t.text     "terms"
    t.float    "social_interactions_multiplier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hashtag_challenges", ["badge_id"], name: "index_hashtag_challenges_on_badge_id", using: :btree

  create_table "how_to_point_items", force: true do |t|
    t.integer  "points"
    t.string   "description"
    t.string   "section"
    t.integer  "domain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "how_to_point_items", ["domain_id"], name: "index_how_to_point_items_on_domain_id", using: :btree

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "access_token"
    t.string   "access_token_secret"
    t.text     "json"
    t.integer  "domain_id"
    t.string   "avatar"
    t.string   "refresh_token"
    t.boolean  "token_invalid",       default: false
    t.text     "scopes"
    t.text     "fb_pages"
  end

  add_index "identities", ["domain_id"], name: "index_identities_on_domain_id", using: :btree
  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "invites", force: true do |t|
    t.string   "email"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  create_table "invoices", force: true do |t|
    t.integer  "subscription_id"
    t.integer  "amount"
    t.datetime "creditation_date"
    t.integer  "moip_code"
    t.string   "items"
    t.integer  "status_code"
    t.integer  "subscription_code"
    t.integer  "occurrence"
    t.integer  "customer_code"
    t.string   "customer_fullname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status_description"
  end

  add_index "invoices", ["subscription_id"], name: "index_invoices_on_subscription_id", using: :btree

  create_table "memberships", force: true do |t|
    t.integer  "user_id"
    t.integer  "domain_id"
    t.integer  "role",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["domain_id"], name: "index_memberships_on_domain_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "messages", force: true do |t|
    t.text     "body"
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "read_at"
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "newsletters", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "newsletters", ["email"], name: "index_newsletters_on_email", unique: true, using: :btree

  create_table "notification_users", force: true do |t|
    t.integer  "notification_id"
    t.integer  "user_id"
    t.boolean  "is_read",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notification_users", ["notification_id"], name: "index_notification_users_on_notification_id", using: :btree
  add_index "notification_users", ["user_id"], name: "index_notification_users_on_user_id", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "recipient_id"
    t.integer  "actor_id"
    t.string   "action"
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oauth2_infos", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "access_token"
    t.string   "refresh_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", force: true do |t|
    t.string   "name"
    t.integer  "duration"
    t.string   "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "created_on_moip",      default: false
    t.string   "moip_code"
    t.integer  "amount"
    t.integer  "setup_fee"
    t.string   "interval_unit"
    t.string   "status"
    t.string   "description"
    t.integer  "billing_cycles"
    t.integer  "trial_days"
    t.integer  "trial_hold_setup_fee"
    t.boolean  "active",               default: true
  end

  create_table "points", force: true do |t|
    t.integer  "user_id"
    t.integer  "pointable_id"
    t.string   "pointable_type"
    t.integer  "value",          default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "points", ["pointable_id", "pointable_type"], name: "index_points_on_pointable_id_and_pointable_type", using: :btree
  add_index "points", ["user_id"], name: "index_points_on_user_id", using: :btree

  create_table "post_views", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_views", ["post_id"], name: "index_post_views_on_post_id", using: :btree
  add_index "post_views", ["user_id"], name: "index_post_views_on_user_id", using: :btree

  create_table "posts", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "notify_users", default: false
  end

  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "question_answers", force: true do |t|
    t.integer  "user_id"
    t.integer  "step_question_id"
    t.integer  "step_question_option_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "score_added",             default: false
  end

  add_index "question_answers", ["step_question_id"], name: "index_question_answers_on_step_question_id", using: :btree
  add_index "question_answers", ["step_question_option_id"], name: "index_question_answers_on_step_question_option_id", using: :btree
  add_index "question_answers", ["user_id"], name: "index_question_answers_on_user_id", using: :btree

  create_table "questions", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.integer  "step_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "archive"
  end

  add_index "questions", ["step_id"], name: "index_questions_on_step_id", using: :btree
  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree

  create_table "quiz_answers", force: true do |t|
    t.integer  "user_id"
    t.integer  "step_id"
    t.boolean  "bonus_added", default: false
    t.integer  "bonus",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quiz_answers", ["step_id"], name: "index_quiz_answers_on_step_id", using: :btree
  add_index "quiz_answers", ["user_id"], name: "index_quiz_answers_on_user_id", using: :btree

  create_table "reservas", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.integer  "curso_landing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reservas", ["curso_landing_id"], name: "index_reservas_on_curso_landing_id", using: :btree

  create_table "search_items", force: true do |t|
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "datetime"
  end

  add_index "search_items", ["content"], name: "index_search_items_on_content", using: :btree
  add_index "search_items", ["datetime"], name: "index_search_items_on_datetime", using: :btree
  add_index "search_items", ["searchable_id", "searchable_type"], name: "index_search_items_on_searchable_id_and_searchable_type", using: :btree

  create_table "step_question_options", force: true do |t|
    t.string   "content"
    t.boolean  "correct",          default: false
    t.integer  "step_question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "step_questions", force: true do |t|
    t.string   "question"
    t.string   "hint"
    t.integer  "score"
    t.integer  "step_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "steps", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "chapter_id"
    t.text     "description"
    t.integer  "topic_id"
    t.integer  "position"
    t.string   "step_type"
    t.boolean  "free",        default: false
    t.integer  "score",       default: 0
  end

  add_index "steps", ["topic_id"], name: "index_steps_on_topic_id", using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id"
    t.integer  "moip_code"
    t.string   "status"
    t.datetime "remote_creation_date"
    t.integer  "amount"
    t.integer  "plan_id"
    t.datetime "next_invoice_date"
    t.datetime "trial_start_time"
    t.datetime "trial_end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "not_renew",            default: false
    t.datetime "active_until"
    t.datetime "first_paid_day"
    t.datetime "suspend_in"
    t.datetime "suspended_in"
    t.integer  "voucher_id"
  end

  add_index "subscriptions", ["plan_id"], name: "index_subscriptions_on_plan_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree
  add_index "subscriptions", ["voucher_id"], name: "index_subscriptions_on_voucher_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "timeline_items", force: true do |t|
    t.integer  "timelineable_id"
    t.string   "timelineable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "item_type"
    t.boolean  "visible",           default: true
    t.boolean  "pinned",            default: false
  end

  add_index "timeline_items", ["timelineable_id", "timelineable_type"], name: "index_timeline_items_on_timelineable_id_and_timelineable_type", using: :btree

  create_table "token_login_tokens", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "token_login_tokens", ["user_id"], name: "index_token_login_tokens_on_user_id", using: :btree

  create_table "tokens", force: true do |t|
    t.integer  "user_id"
    t.string   "key"
    t.datetime "valid_until"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tokens", ["user_id"], name: "index_tokens_on_user_id", using: :btree

  create_table "trails", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "slug"
    t.string   "hours"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.string   "age_group"
    t.string   "video_url"
    t.boolean  "active",      default: true
  end

  create_table "trivias_answers", force: true do |t|
    t.integer  "question_id"
    t.integer  "play_id"
    t.boolean  "correct"
    t.integer  "seconds_took"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "option_id"
  end

  add_index "trivias_answers", ["correct"], name: "index_trivias_answers_on_correct", using: :btree
  add_index "trivias_answers", ["option_id"], name: "index_trivias_answers_on_option_id", using: :btree
  add_index "trivias_answers", ["play_id"], name: "index_trivias_answers_on_play_id", using: :btree
  add_index "trivias_answers", ["question_id"], name: "index_trivias_answers_on_question_id", using: :btree

  create_table "trivias_options", force: true do |t|
    t.string   "name"
    t.boolean  "correct"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trivias_options", ["question_id"], name: "index_trivias_options_on_question_id", using: :btree

  create_table "trivias_plays", force: true do |t|
    t.integer  "user_id"
    t.text     "questions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "stopped"
    t.string   "stop_reason"
  end

  add_index "trivias_plays", ["stop_reason"], name: "index_trivias_plays_on_stop_reason", using: :btree
  add_index "trivias_plays", ["stopped"], name: "index_trivias_plays_on_stopped", using: :btree
  add_index "trivias_plays", ["user_id"], name: "index_trivias_plays_on_user_id", using: :btree

  create_table "trivias_questions", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "trivia_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trivias_questions", ["trivia_id"], name: "index_trivias_questions_on_trivia_id", using: :btree

  create_table "trivias_remove_question_from_plays", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trivias_trivia", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.datetime "published_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trivias_user_answers", force: true do |t|
    t.integer  "user_trivia_id"
    t.integer  "question_id"
    t.integer  "option_id"
    t.boolean  "correct"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trivias_user_answers", ["correct"], name: "index_trivias_user_answers_on_correct", using: :btree
  add_index "trivias_user_answers", ["option_id"], name: "index_trivias_user_answers_on_option_id", using: :btree
  add_index "trivias_user_answers", ["question_id"], name: "index_trivias_user_answers_on_question_id", using: :btree
  add_index "trivias_user_answers", ["user_trivia_id"], name: "index_trivias_user_answers_on_user_trivia_id", using: :btree

  create_table "trivias_user_trivia", force: true do |t|
    t.integer  "user_id"
    t.integer  "trivia_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trivias_user_trivia", ["trivia_id"], name: "index_trivias_user_trivia_on_trivia_id", using: :btree
  add_index "trivias_user_trivia", ["user_id"], name: "index_trivias_user_trivia_on_user_id", using: :btree

  create_table "user_steps", force: true do |t|
    t.integer  "user_id"
    t.integer  "step_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_steps", ["step_id"], name: "index_user_steps_on_step_id", using: :btree
  add_index "user_steps", ["user_id"], name: "index_user_steps_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                              default: "",    null: false
    t.string   "encrypted_password",                 default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.boolean  "needs_edit",                         default: true
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "plan_id"
    t.datetime "expires_in"
    t.string   "website"
    t.text     "bio"
    t.string   "location"
    t.string   "username"
    t.string   "lang"
    t.string   "timezone"
    t.string   "country"
    t.boolean  "see_sensitive_media",                default: false
    t.boolean  "mark_sensitive_media",               default: false
    t.text     "facebook_json"
    t.integer  "sash_id"
    t.integer  "level",                              default: 0
    t.integer  "ranking_position"
    t.integer  "indicator_id"
    t.string   "cpf"
    t.string   "phone"
    t.datetime "birthdate"
    t.string   "moip_code"
    t.boolean  "has_submited_payment_form",          default: false
    t.boolean  "master",                             default: false
    t.boolean  "renew",                              default: true
    t.datetime "expires_at"
    t.string   "moip_signature_code"
    t.string   "signature_status"
    t.string   "cancel_reason"
    t.boolean  "admin",                              default: false
    t.boolean  "mailed_welcome",                     default: false
    t.integer  "sum_points",                         default: 0
    t.boolean  "created_in_dash",                    default: false
    t.string   "voucher"
    t.boolean  "can_manage_all_domains",             default: false
    t.string   "locale"
    t.text     "youtube_channel_id_to_monitor"
    t.text     "facebook_page_id_to_monitor"
    t.boolean  "registration_complete",              default: false
    t.datetime "next_youtube_collect"
    t.datetime "next_facebook_collect"
    t.datetime "next_instagram_collect"
    t.datetime "last_access"
    t.string   "facebook_page_name_to_monitor"
    t.string   "facebook_page_picture_to_monitor"
    t.string   "youtube_channel_name_to_monitor"
    t.string   "youtube_channel_picture_to_monitor"
    t.string   "unsubscribe_token"
    t.boolean  "subscribe",                          default: true
    t.boolean  "has_sent_access_token_expired_mail", default: false
    t.string   "token_login"
    t.boolean  "must_alter_password"
    t.datetime "next_twitter_advocacy_collect"
    t.datetime "next_facebook_advocacy_collect"
    t.integer  "available_coins",                    default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["indicator_id"], name: "index_users_on_indicator_id", using: :btree
  add_index "users", ["plan_id"], name: "index_users_on_plan_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unsubscribe_token"], name: "index_users_on_unsubscribe_token", unique: true, using: :btree

  create_table "visualizations", force: true do |t|
    t.integer  "user_id"
    t.integer  "broadcast_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  add_index "visualizations", ["user_id", "broadcast_id"], name: "index_visualizations_on_user_id_and_broadcast_id", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.integer "user_id"
    t.integer "answer_id"
    t.integer "question_id"
    t.string  "status"
    t.integer "score",         default: 0
    t.integer "voteable_id"
    t.string  "voteable_type"
  end

  add_index "votes", ["answer_id"], name: "index_votes_on_answer_id", using: :btree
  add_index "votes", ["question_id"], name: "index_votes_on_question_id", using: :btree
  add_index "votes", ["user_id"], name: "index_votes_on_user_id", using: :btree
  add_index "votes", ["voteable_id", "voteable_type"], name: "index_votes_on_voteable_id_and_voteable_type", using: :btree

  create_table "vouchers", force: true do |t|
    t.string   "code"
    t.integer  "plan_id"
    t.integer  "price"
    t.datetime "valid_until"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "used_at"
  end

  add_index "vouchers", ["plan_id"], name: "index_vouchers_on_plan_id", using: :btree

end
