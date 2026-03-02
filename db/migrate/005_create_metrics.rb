# db/migrate/YYYYMMDDHHMMSS_create_metrics.rb
class CreateMetrics < ActiveRecord::Migration[7.2]
  def change
    create_table :metrics do |t|
      t.references :driver, null: false, foreign_key: true
      t.references :race, foreign_key: true  # Null = season aggregate
      t.integer :season, null: false

      # Calculated metrics
      t.decimal :performance_index, precision: 5, scale: 2
      t.decimal :consistency_score, precision: 5, scale: 2
      t.decimal :race_pace, precision: 5, scale: 2
      t.decimal :quali_pace, precision: 5, scale: 2
      t.decimal :recent_form, precision: 5, scale: 2  # Rolling avg 3 races
      
      # Positions gained/lost
      t.integer :positions_gained
      t.decimal :avg_grid_position, precision: 5, scale: 2
      t.decimal :avg_finish_position, precision: 5, scale: 2

      t.timestamps
    end

    add_index :metrics, [:driver_id, :race_id], unique: true
    add_index :metrics, [:driver_id, :season]
    add_index :metrics, :performance_index
  end
end
