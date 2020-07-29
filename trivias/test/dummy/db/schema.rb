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

ActiveRecord::Schema.define(version: 20160401012614) do

  create_table "trivias_answers", force: true do |t|
    t.integer  "question_id"
    t.integer  "play_id"
    t.boolean  "correct"
    t.integer  "seconds_took"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "option_id"
  end

  add_index "trivias_answers", ["correct"], name: "index_trivias_answers_on_correct"
  add_index "trivias_answers", ["option_id"], name: "index_trivias_answers_on_option_id"
  add_index "trivias_answers", ["play_id"], name: "index_trivias_answers_on_play_id"
  add_index "trivias_answers", ["question_id"], name: "index_trivias_answers_on_question_id"

  create_table "trivias_options", force: true do |t|
    t.string   "name"
    t.boolean  "correct"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trivias_options", ["question_id"], name: "index_trivias_options_on_question_id"

  create_table "trivias_plays", force: true do |t|
    t.integer  "user_id"
    t.text     "questions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "stopped"
    t.string   "stop_reason"
  end

  add_index "trivias_plays", ["stop_reason"], name: "index_trivias_plays_on_stop_reason"
  add_index "trivias_plays", ["stopped"], name: "index_trivias_plays_on_stopped"
  add_index "trivias_plays", ["user_id"], name: "index_trivias_plays_on_user_id"

  create_table "trivias_questions", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "trivia_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trivias_questions", ["trivia_id"], name: "index_trivias_questions_on_trivia_id"

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

  add_index "trivias_user_answers", ["correct"], name: "index_trivias_user_answers_on_correct"
  add_index "trivias_user_answers", ["option_id"], name: "index_trivias_user_answers_on_option_id"
  add_index "trivias_user_answers", ["question_id"], name: "index_trivias_user_answers_on_question_id"
  add_index "trivias_user_answers", ["user_trivia_id"], name: "index_trivias_user_answers_on_user_trivia_id"

  create_table "trivias_user_trivia", force: true do |t|
    t.integer  "user_id"
    t.integer  "trivia_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trivias_user_trivia", ["trivia_id"], name: "index_trivias_user_trivia_on_trivia_id"
  add_index "trivias_user_trivia", ["user_id"], name: "index_trivias_user_trivia_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
