# frozen_string_literal: true

# app/models/driver.rb
class Driver < ApplicationRecord
  belongs_to :team
  has_many :results, dependent: :destroy
  has_many :races, through: :results
  has_many :metrics, dependent: :destroy
  has_many :driver_news, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :season, presence: true, numericality: { only_integer: true }
  validates :code, length: { is: 3 }, allow_nil: true

  scope :active, -> { where(active: true) }
  scope :for_season, ->(season) { where(season: season) }
  scope :current_season, -> { for_season(Date.current.year) }
  scope :by_points, lambda {
    left_joins(:results)
      .group(:id)
      .order(Arel.sql("COALESCE(SUM(results.points), 0) DESC"))
  }

  def full_name
    "#{first_name} #{last_name}"
  end

  def display_name
    code.present? ? "#{code} - #{full_name}" : full_name
  end

  def total_points
    results.sum(:points)
  end

  def championship_position
    Driver.for_season(season).by_points.pluck(:id).index(id)&.+(1)
  end

  def teammate
    team.drivers.where(season: season).where.not(id: id).first
  end

  def head_to_head_vs_teammate
    return nil unless teammate

    my_wins = results.joins(:race).where(races: { status: "completed" })
                     .where(final_position: ...teammate.results.joins(:race)
                                               .where(races: { id: results.joins(:race).select("races.id") })
                                               .select(:final_position))
                     .count

    teammate_wins = teammate.results.count - my_wins
    { wins: my_wins, losses: teammate_wins }
  end

  def recent_form(races_count = 3)
    recent_results = results.joins(:race)
                            .where(races: { status: "completed" })
                            .order("races.date DESC")
                            .limit(races_count)

    return nil if recent_results.empty?

    recent_results.average(:points)&.round(2)
  end

  def recent_news
    driver_news.recent.limit(5)
  end

  def critical_news
    driver_news.high_impact.affects_performance.recent
  end

  def active_penalties?
    driver_news.category_penalty.recent.any?
  end

  def wet_weather_specialist?
    # Calculate performance in wet vs dry conditions
    wet_results = results.joins(race: :weather_conditions)
                         .where(weather_conditions: { condition: %w[Wet Mixed Damp] })
    dry_results = results.joins(race: :weather_conditions)
                         .where(weather_conditions: { condition: "Dry" })

    return false if wet_results.empty? || dry_results.empty?

    wet_avg = wet_results.average(:points) || 0
    dry_avg = dry_results.average(:points) || 0

    wet_avg > dry_avg
  end
end
