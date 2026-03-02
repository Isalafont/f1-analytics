# db/migrate/YYYYMMDDHHMMSS_create_team_news.rb
class CreateTeamNews < ActiveRecord::Migration[7.2]
  def change
    create_table :team_news do |t|
      t.references :team, foreign_key: true  # Null if affects multiple teams
      t.string :category, null: false   # technical, personnel, strategy, penalty, regulation
      t.string :title, null: false
      t.text :description
      t.date :event_date, null: false
      t.string :source                  # URL or source name
      t.string :impact_level            # high, medium, low
      t.boolean :affects_performance, default: false

      t.timestamps
    end

    add_index :team_news, :event_date
    add_index :team_news, :category
    add_index :team_news, :impact_level
    add_index :team_news, :affects_performance
  end
end
