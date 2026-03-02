# db/migrate/YYYYMMDDHHMMSS_create_races.rb
class CreateRaces < ActiveRecord::Migration[7.2]
  def change
    create_table :races do |t|
      t.string :name, null: false
      t.string :circuit, null: false
      t.string :country
      t.integer :round, null: false
      t.integer :season, null: false
      t.date :date, null: false
      t.time :time
      t.string :status, default: 'scheduled'  # scheduled, completed, cancelled

      t.timestamps
    end

    add_index :races, [:season, :round], unique: true
    add_index :races, :date
    add_index :races, :status
  end
end
