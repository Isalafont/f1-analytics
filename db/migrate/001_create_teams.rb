# db/migrate/YYYYMMDDHHMMSS_create_teams.rb
class CreateTeams < ActiveRecord::Migration[7.2]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.string :constructor, null: false
      t.string :color_primary
      t.string :color_secondary
      t.integer :season, null: false
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :teams, [:name, :season], unique: true
    add_index :teams, :active
  end
end
