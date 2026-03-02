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

ActiveRecord::Schema[7.2].define(version: 8) do
  create_table "driver_news", force: :cascade do |t|
    t.integer "driver_id"
    t.string "category", null: false
    t.string "title", null: false
    t.text "description"
    t.date "event_date", null: false
    t.string "source"
    t.string "impact_level"
    t.boolean "affects_performance", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["affects_performance"], name: "index_driver_news_on_affects_performance"
    t.index ["category"], name: "index_driver_news_on_category"
    t.index ["driver_id"], name: "index_driver_news_on_driver_id"
    t.index ["event_date"], name: "index_driver_news_on_event_date"
    t.index ["impact_level"], name: "index_driver_news_on_impact_level"
  end

  create_table "drivers", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.integer "number"
    t.string "code", limit: 3
    t.string "nationality"
    t.date "birth_date"
    t.integer "team_id", null: false
    t.integer "season", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_drivers_on_active"
    t.index ["code"], name: "index_drivers_on_code"
    t.index ["last_name", "season"], name: "index_drivers_on_last_name_and_season"
    t.index ["team_id"], name: "index_drivers_on_team_id"
  end

  create_table "metrics", force: :cascade do |t|
    t.integer "driver_id", null: false
    t.integer "race_id"
    t.integer "season", null: false
    t.decimal "performance_index", precision: 5, scale: 2
    t.decimal "consistency_score", precision: 5, scale: 2
    t.decimal "race_pace", precision: 5, scale: 2
    t.decimal "quali_pace", precision: 5, scale: 2
    t.decimal "recent_form", precision: 5, scale: 2
    t.integer "positions_gained"
    t.decimal "avg_grid_position", precision: 5, scale: 2
    t.decimal "avg_finish_position", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id", "race_id"], name: "index_metrics_on_driver_id_and_race_id", unique: true
    t.index ["driver_id", "season"], name: "index_metrics_on_driver_id_and_season"
    t.index ["driver_id"], name: "index_metrics_on_driver_id"
    t.index ["performance_index"], name: "index_metrics_on_performance_index"
    t.index ["race_id"], name: "index_metrics_on_race_id"
  end

  create_table "races", force: :cascade do |t|
    t.string "name", null: false
    t.string "circuit", null: false
    t.string "country"
    t.integer "round", null: false
    t.integer "season", null: false
    t.date "date", null: false
    t.time "time"
    t.string "status", default: "scheduled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_races_on_date"
    t.index ["season", "round"], name: "index_races_on_season_and_round", unique: true
    t.index ["status"], name: "index_races_on_status"
  end

  create_table "results", force: :cascade do |t|
    t.integer "race_id", null: false
    t.integer "driver_id", null: false
    t.integer "grid_position"
    t.integer "final_position"
    t.integer "points", default: 0
    t.string "status"
    t.integer "laps_completed"
    t.string "fastest_lap_time"
    t.integer "fastest_lap_rank"
    t.boolean "fastest_lap", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_results_on_driver_id"
    t.index ["final_position"], name: "index_results_on_final_position"
    t.index ["points"], name: "index_results_on_points"
    t.index ["race_id", "driver_id"], name: "index_results_on_race_id_and_driver_id", unique: true
    t.index ["race_id"], name: "index_results_on_race_id"
  end

  create_table "team_news", force: :cascade do |t|
    t.integer "team_id"
    t.string "category", null: false
    t.string "title", null: false
    t.text "description"
    t.date "event_date", null: false
    t.string "source"
    t.string "impact_level"
    t.boolean "affects_performance", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["affects_performance"], name: "index_team_news_on_affects_performance"
    t.index ["category"], name: "index_team_news_on_category"
    t.index ["event_date"], name: "index_team_news_on_event_date"
    t.index ["impact_level"], name: "index_team_news_on_impact_level"
    t.index ["team_id"], name: "index_team_news_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "constructor", null: false
    t.string "color_primary"
    t.string "color_secondary"
    t.integer "season", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_teams_on_active"
    t.index ["name", "season"], name: "index_teams_on_name_and_season", unique: true
  end

  create_table "weather_conditions", force: :cascade do |t|
    t.integer "race_id", null: false
    t.string "session_type", null: false
    t.string "condition"
    t.decimal "air_temp", precision: 5, scale: 2
    t.decimal "track_temp", precision: 5, scale: 2
    t.integer "humidity"
    t.decimal "wind_speed", precision: 5, scale: 2
    t.string "wind_direction"
    t.integer "rainfall"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["condition"], name: "index_weather_conditions_on_condition"
    t.index ["race_id", "session_type"], name: "index_weather_conditions_on_race_id_and_session_type", unique: true
    t.index ["race_id"], name: "index_weather_conditions_on_race_id"
  end

  add_foreign_key "driver_news", "drivers"
  add_foreign_key "drivers", "teams"
  add_foreign_key "metrics", "drivers"
  add_foreign_key "metrics", "races"
  add_foreign_key "results", "drivers"
  add_foreign_key "results", "races"
  add_foreign_key "team_news", "teams"
  add_foreign_key "weather_conditions", "races"
end
