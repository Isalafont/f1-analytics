# db/migrate/YYYYMMDDHHMMSS_create_driver_news.rb
class CreateDriverNews < ActiveRecord::Migration[7.2]
  def change
    create_table :driver_news do |t|
      t.references :driver, foreign_key: true  # Null if affects multiple drivers
      t.string :category, null: false   # injury, penalty, contract, engineer_change, personal
      t.string :title, null: false
      t.text :description
      t.date :event_date, null: false
      t.string :source                  # URL or source name
      t.string :impact_level            # high, medium, low
      t.boolean :affects_performance, default: false

      t.timestamps
    end

    add_index :driver_news, :event_date
    add_index :driver_news, :category
    add_index :driver_news, :impact_level
    add_index :driver_news, :affects_performance
  end
end
