# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_11_27_080635) do
  create_table "heroes", force: :cascade do |t|
    t.string "name", null: false
    t.string "localized_name", null: false
    t.string "image_link", null: false
    t.integer "primary_attr", default: 0
    t.integer "complexity", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_heroes", force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "hero_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hero_id"], name: "index_team_heroes_on_hero_id"
    t.index ["team_id"], name: "index_team_heroes_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.integer "category", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "team_heroes", "heroes"
  add_foreign_key "team_heroes", "teams"
end
