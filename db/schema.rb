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

ActiveRecord::Schema.define(version: 2021_07_29_181343) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_users", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "is_game_winner"
  end

  create_table "games", force: :cascade do |t|
    t.jsonb "go_fish"
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "started_at"
    t.integer "player_count"
    t.bigint "winner_id"
    t.string "title"
    t.integer "minimum_player_count"
    t.integer "maximum_player_count"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end


  create_view "user_stats", sql_definition: <<-SQL
      SELECT users.id,
      users.name,
      count(game_users.*) AS played_games,
      count(
          CASE
              WHEN game_users.is_game_winner THEN 1
              ELSE NULL::integer
          END) AS won_games,
      (count(game_users.*) - count(
          CASE
              WHEN game_users.is_game_winner THEN 1
              ELSE NULL::integer
          END)) AS lost_games,
      sum((games.finished_at - games.started_at)) AS game_time
     FROM ((users
       JOIN game_users ON ((game_users.user_id = users.id)))
       JOIN games ON ((games.id = game_users.game_id)))
    GROUP BY users.name, users.id
    ORDER BY (count(
          CASE
              WHEN game_users.is_game_winner THEN 1
              ELSE NULL::integer
          END)) DESC;
  SQL
end
