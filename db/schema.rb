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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110613212149) do

  create_table "achievements", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "group"
    t.string   "slug"
    t.integer  "category_id"
  end

  add_index "achievements", ["category_id"], :name => "index_achievements_on_category_id"
  add_index "achievements", ["id"], :name => "index_achievements_on_id"
  add_index "achievements", ["name"], :name => "index_achievements_on_name"

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.string   "secret"
  end

  add_index "authentications", ["id"], :name => "index_authentications_on_id"
  add_index "authentications", ["provider", "uid"], :name => "index_authentications_on_provider_and_uid"
  add_index "authentications", ["uid", "provider"], :name => "index_authentications_on_uid_and_provider"
  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "blocks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "receiver_id"
    t.boolean  "flag"
    t.text     "flag_reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blocks", ["id"], :name => "index_blocks_on_id"
  add_index "blocks", ["receiver_id"], :name => "index_blocks_on_receiver_id"
  add_index "blocks", ["user_id"], :name => "index_blocks_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "highlighted"
  end

  add_index "categories", ["id"], :name => "index_categories_on_id"

  create_table "challenges", :force => true do |t|
    t.integer  "author_id"
    t.string   "title"
    t.text     "details"
    t.boolean  "editor_pick"
    t.string   "location"
    t.float    "lat"
    t.float    "lng"
    t.integer  "points"
    t.integer  "budget"
    t.integer  "city"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.integer  "achievement_id"
    t.integer  "sum_todo_list"
    t.integer  "sum_completed"
    t.string   "proof"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published"
    t.integer  "weather"
    t.string   "url_name"
    t.string   "url_link"
    t.integer  "subscribed_challenges_count"
    t.integer  "category_id"
    t.boolean  "vetted"
  end

  add_index "challenges", ["achievement_id"], :name => "index_challenges_on_achievement_id"
  add_index "challenges", ["author_id"], :name => "index_challenges_on_author_id"
  add_index "challenges", ["category_id"], :name => "index_challenges_on_category_id"
  add_index "challenges", ["id"], :name => "index_challenges_on_id"

  create_table "city_requests", :force => true do |t|
    t.string   "email"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "lng"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "plan_id"
  end

  add_index "comments", ["id"], :name => "index_comments_on_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "deleted_users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.integer  "login_count"
    t.datetime "account_creation"
    t.text     "why"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deleted_users", ["id"], :name => "index_deleted_users_on_id"

  create_table "dislikes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "challenge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dislikes", ["challenge_id"], :name => "index_dislikes_on_challenge_id"
  add_index "dislikes", ["id"], :name => "index_dislikes_on_id"
  add_index "dislikes", ["user_id"], :name => "index_dislikes_on_user_id"

  create_table "invites", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invites", ["id"], :name => "index_invites_on_id"

  create_table "likes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "subscribed_challenge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "likes", ["id"], :name => "index_likes_on_id"
  add_index "likes", ["subscribed_challenge_id"], :name => "index_likes_on_subscribed_challenge_id"
  add_index "likes", ["user_id"], :name => "index_likes_on_user_id"

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "receiver_id"
    t.text     "message"
    t.boolean  "unread_receiver",  :default => true
    t.boolean  "deleted_receiver", :default => false
    t.boolean  "warned",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["id"], :name => "index_messages_on_id"
  add_index "messages", ["receiver_id"], :name => "index_messages_on_receiver_id"
  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "plans", :force => true do |t|
    t.integer  "challenge_id"
    t.boolean  "featured"
    t.integer  "privacy"
    t.integer  "host_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "attendance_cap"
    t.text     "note"
    t.integer  "subscribed_plans_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.decimal  "price",                  :precision => 10, :scale => 2
    t.string   "location"
    t.float    "lat"
    t.float    "lng"
    t.text     "transportation"
    t.string   "url_link"
    t.string   "url_name"
    t.string   "photo_file_name"
    t.integer  "photo_file_size"
    t.string   "photo_content_type"
    t.string   "image_file_name"
    t.integer  "image_file_size"
    t.string   "image_content_type"
    t.integer  "city_id"
  end

  create_table "subscribed_achievements", :force => true do |t|
    t.integer  "user_id"
    t.integer  "achievement_id"
    t.integer  "level"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscribed_achievements", ["achievement_id"], :name => "index_subscribed_achievements_on_achievement_id"
  add_index "subscribed_achievements", ["id"], :name => "index_subscribed_achievements_on_id"
  add_index "subscribed_achievements", ["user_id"], :name => "index_subscribed_achievements_on_user_id"

  create_table "subscribed_challenges", :force => true do |t|
    t.integer  "user_id"
    t.integer  "challenge_id"
    t.text     "note"
    t.datetime "goal_date"
    t.boolean  "completed"
    t.string   "proof_file_name"
    t.string   "proof_content_type"
    t.integer  "proof_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date_completed_on"
    t.integer  "points_awarded"
    t.string   "panda_video_id"
    t.string   "proof_remote_url"
    t.text     "completed_note"
    t.integer  "private"
  end

  add_index "subscribed_challenges", ["challenge_id"], :name => "index_subscribed_challenges_on_challenge_id"
  add_index "subscribed_challenges", ["id"], :name => "index_subscribed_challenges_on_id"
  add_index "subscribed_challenges", ["user_id"], :name => "index_subscribed_challenges_on_user_id"

  create_table "subscribed_plans", :force => true do |t|
    t.integer  "plan_id"
    t.integer  "user_id"
    t.integer  "num_guests"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "maybe"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                                      :default => "",   :null => false
    t.string   "username"
    t.string   "location_city"
    t.float    "lat"
    t.float    "lng"
    t.string   "avatar_file_name"
    t.string   "avatar_content_size"
    t.integer  "avatar_file_size"
    t.integer  "score",                                      :default => 1
    t.boolean  "privacy_allow_messages",                     :default => true
    t.boolean  "privacy_cc_email",                           :default => true
    t.string   "source"
    t.text     "about_me"
    t.integer  "mod_level",                                  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",          :limit => 128, :default => "",   :null => false
    t.string   "password_salt",                              :default => "",   :null => false
    t.string   "authentication_token"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                              :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "hometown"
    t.integer  "hidden_reputation",                          :default => 100
    t.boolean  "active",                                     :default => true
    t.string   "website_link"
    t.string   "facebook_link"
    t.integer  "gender"
    t.datetime "birthday"
    t.string   "temp_password"
    t.boolean  "small_twitter_pic"
    t.string   "twitter_link"
    t.boolean  "privacy_block_adventure_log"
    t.boolean  "autopost_twitter_bucket"
    t.boolean  "autopost_twitter_completed"
    t.boolean  "autopost_facebook_bucket"
    t.boolean  "autopost_facebook_completed"
    t.boolean  "messaging_weekly_email",                     :default => true
    t.boolean  "fb_extended_permissions"
    t.integer  "privacy_achievement",                        :default => 0
    t.integer  "privacy_bucket",                             :default => 0
    t.boolean  "messaging_bucket_comment",                   :default => true
    t.string   "phone_OS"
    t.string   "phone_model"
    t.string   "app_version"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token"
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["id"], :name => "index_users_on_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username"

end
