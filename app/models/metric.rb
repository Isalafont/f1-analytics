# app/models/metric.rb
class Metric < ApplicationRecord
  belongs_to :driver
  belongs_to :race, optional: true

  validates :driver, presence: true
  validates :season, presence: true, numericality: { only_integer: true }
  validates :driver_id, uniqueness: { scope: :race_id }, if: :race_id?

  scope :for_season, ->(season) { where(season: season) }
  scope :race_metrics, -> { where.not(race_id: nil) }
  scope :season_aggregates, -> { where(race_id: nil) }
  scope :top_performers, -> { order(performance_index: :desc) }

  def self.calculate_for_driver(driver, race = nil)
    metric = find_or_initialize_by(driver: driver, race: race, season: driver.season)
    
    results = if race
                driver.results.where(race: race)
              else
                driver.results.joins(:race).where(races: { season: driver.season, status: 'completed' })
              end

    return metric if results.empty?

    # Performance Index (0-100)
    # Points scored weighted by team reliability
    total_points = results.sum(:points)
    races_completed = results.count
    dnf_penalty = results.where.not(status: 'Finished').count * 5
    metric.performance_index = [[total_points - dnf_penalty, 0].max, 100].min

    # Consistency Score (0-100)
    # Lower variance = higher score
    positions = results.where.not(final_position: nil).pluck(:final_position)
    if positions.any?
      avg_position = positions.sum.to_f / positions.size
      variance = positions.map { |p| (p - avg_position)**2 }.sum / positions.size
      metric.consistency_score = [100 - (variance * 2), 0].max
    end

    # Race Pace (avg positions gained)
    gains = results.map(&:positions_gained).compact
    metric.race_pace = gains.any? ? (gains.sum.to_f / gains.size).round(2) : 0

    # Quali Pace
    grid_positions = results.where.not(grid_position: nil).pluck(:grid_position)
    metric.quali_pace = grid_positions.any? ? (grid_positions.sum.to_f / grid_positions.size).round(2) : 0
    metric.avg_grid_position = metric.quali_pace

    # Average finish position
    finish_positions = results.where(status: 'Finished').pluck(:final_position)
    metric.avg_finish_position = finish_positions.any? ? (finish_positions.sum.to_f / finish_positions.size).round(2) : 0

    # Recent Form (last 3 races rolling average)
    recent = driver.results.joins(:race)
                   .where(races: { status: 'completed' })
                   .order('races.date DESC')
                   .limit(3)
    metric.recent_form = recent.average(:points)&.round(2) || 0

    # Positions gained total
    metric.positions_gained = gains.sum

    metric.save
    metric
  end
end
