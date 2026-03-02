# db/migrate/YYYYMMDDHHMMSS_create_drivers.rb
class CreateDrivers < ActiveRecord::Migration[7.2]
  def change
    create_table :drivers do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :number
      t.string :code, limit: 3  # VER, HAM, LEC, etc.
      t.string :nationality
      t.date :birth_date
      t.references :team, null: false, foreign_key: true
      t.integer :season, null: false
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :drivers, [:last_name, :season]
    add_index :drivers, :code
    add_index :drivers, :active
  end
end
