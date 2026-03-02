# db/migrate/YYYYMMDDHHMMSS_create_results.rb
class CreateResults < ActiveRecord::Migration[7.2]
  def change
    create_table :results do |t|
      t.references :race, null: false, foreign_key: true
      t.references :driver, null: false, foreign_key: true
      t.integer :grid_position  # Quali result
      t.integer :final_position
      t.integer :points, default: 0
      t.string :status  # Finished, DNF, DNS, DSQ, etc.
      t.integer :laps_completed
      t.string :fastest_lap_time
      t.integer :fastest_lap_rank
      t.boolean :fastest_lap, default: false

      t.timestamps
    end

    add_index :results, [:race_id, :driver_id], unique: true
    add_index :results, :final_position
    add_index :results, :points
  end
end
