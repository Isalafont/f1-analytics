# db/migrate/YYYYMMDDHHMMSS_create_weather_conditions.rb
class CreateWeatherConditions < ActiveRecord::Migration[7.2]
  def change
    create_table :weather_conditions do |t|
      t.references :race, null: false, foreign_key: true
      t.string :session_type, null: false  # FP1, FP2, FP3, Qualifying, Race
      t.string :condition              # Dry, Wet, Mixed, Damp
      t.decimal :air_temp, precision: 5, scale: 2
      t.decimal :track_temp, precision: 5, scale: 2
      t.integer :humidity              # Percentage
      t.decimal :wind_speed, precision: 5, scale: 2
      t.string :wind_direction
      t.integer :rainfall              # mm
      t.text :notes                    # Additional weather notes

      t.timestamps
    end

    add_index :weather_conditions, [:race_id, :session_type], unique: true
    add_index :weather_conditions, :condition
  end
end
