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

ActiveRecord::Schema.define(version: 20150220055555) do

  create_table "assignments", force: true do |t|
    t.integer  "story_id"
    t.integer  "author_id"
    t.integer  "flag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["author_id"], name: "index_assignments_on_author_id"
  add_index "assignments", ["story_id"], name: "index_assignments_on_story_id"

  create_table "authors", force: true do |t|
    t.string   "fname"
    t.string   "lname"
    t.integer  "role"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "citations", force: true do |t|
    t.integer  "cite_id"
    t.string   "cite_type"
    t.string   "title"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "citations", ["cite_id", "cite_type"], name: "index_citations_on_cite_id_and_cite_type"

  create_table "headlines", force: true do |t|
    t.string   "content"
    t.integer  "story_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "headlines", ["story_id"], name: "index_headlines_on_story_id"

  create_table "leadlines", force: true do |t|
    t.string   "content"
    t.integer  "story_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "leadlines", ["story_id"], name: "index_leadlines_on_story_id"

  create_table "positions", force: true do |t|
    t.integer  "story_id"
    t.integer  "element_id"
    t.string   "element_type"
    t.integer  "position"
    t.boolean  "active"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "positions", ["element_id", "element_type"], name: "index_positions_on_element_id_and_element_type"
  add_index "positions", ["story_id"], name: "index_positions_on_story_id"

  create_table "quote_contents", force: true do |t|
    t.string   "topic"
    t.text     "quote"
    t.string   "quotee_name"
    t.string   "quotee_title"
    t.text     "content"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "relations", force: true do |t|
    t.integer  "story_id"
    t.integer  "tie_id"
    t.string   "tie_type"
    t.string   "heading",    default: "Further reading:"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relations", ["story_id"], name: "index_relations_on_story_id"
  add_index "relations", ["tie_id", "tie_type"], name: "index_relations_on_tie_id_and_tie_type"

  create_table "sections", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "simple_contents", force: true do |t|
    t.string   "topic"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stories", force: true do |t|
    t.string   "subject"
    t.integer  "active_headline_id"
    t.integer  "active_leadline_id"
    t.integer  "section_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "stories", ["section_id"], name: "index_stories_on_section_id"

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
