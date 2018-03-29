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

ActiveRecord::Schema.define(version: 20180328151544) do

  create_table "nflgames", force: :cascade do |t|
    t.string "eid"
    t.string "gsis"
    t.string "d"
    t.string "t"
    t.string "q"
    t.integer "h"
    t.string "hs"
    t.integer "v"
    t.string "vs"
    t.string "rz"
    t.string "ga"
    t.string "gt"
    t.integer "nflweek_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nflweek_id"], name: "index_nflgames_on_nflweek_id"
  end

  create_table "nflplayers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nflteams", force: :cascade do |t|
    t.string "abbr"
    t.string "nn"
    t.string "conf"
    t.string "div"
    t.integer "wins"
    t.integer "losses"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nflweeks", force: :cascade do |t|
    t.string "w"
    t.string "y"
    t.string "t"
    t.string "gd"
    t.string "bph"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
