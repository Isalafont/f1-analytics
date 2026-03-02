# frozen_string_literal: true

class Metric < ApplicationRecord
  belongs_to :driver
  belongs_to :race, optional: true

  validates :season, presence: true, numericality: { only_integer: true }
  validates :driver_id, uniqueness: { scope: :race_id }, if: :race_id?

  scope :for_season, ->(season) { where(season: season) }
  scope :race_metrics, -> { where.not(race_id: nil) }
  scope :season_aggregates, -> { where(race_id: nil) }
  scope :top_performers, -> { order(performance_index: :desc) }

  def self.calculate_for_driver(driver, race = nil)
    metric = find_or_initialize_by(driver: driver, race: race, season: driver.season)
    results = driver_results(driver, race)
    return metric if results.empty?

    assign_metrics(metric, driver, results)
    metric.save
    metric
  end

  def self.assign_metrics(metric, driver, results)
    metric.performance_index = calc_performance_index(results)
    metric.consistency_score = calc_consistency_score(results)
    metric.race_pace = calc_race_pace(results)
    metric.quali_pace = calc_quali_pace(results)
    metric.avg_grid_position = metric.quali_pace
    metric.avg_finish_position = calc_avg_finish(results)
    metric.recent_form = calc_recent_form(driver)
    metric.positions_gained = results.filter_map(&:positions_gained).sum
  end

  def self.driver_results(driver, race)
    return driver.results.where(race: race) if race

    driver.results.joins(:race).where(races: { season: driver.season, status: "completed" })
  end

  def self.calc_performance_index(results)
    dnf_penalty = results.where.not(status: "Finished").count * 5
    (results.sum(:points) - dnf_penalty).clamp(0, 100)
  end

  def self.calc_consistency_score(results)
    positions = results.where.not(final_position: nil).pluck(:final_position)
    return 0 if positions.empty?

    avg = positions.sum.to_f / positions.size
    variance = positions.sum { |p| (p - avg)**2 } / positions.size
    [100 - (variance * 2), 0].max
  end

  def self.calc_race_pace(results)
    gains = results.filter_map(&:positions_gained)
    gains.any? ? (gains.sum.to_f / gains.size).round(2) : 0
  end

  def self.calc_quali_pace(results)
    grids = results.where.not(grid_position: nil).pluck(:grid_position)
    grids.any? ? (grids.sum.to_f / grids.size).round(2) : 0
  end

  def self.calc_avg_finish(results)
    finishes = results.where(status: "Finished").pluck(:final_position)
    finishes.any? ? (finishes.sum.to_f / finishes.size).round(2) : 0
  end

  def self.calc_recent_form(driver)
    driver.results.joins(:race)
          .where(races: { status: "completed" })
          .order("races.date DESC")
          .limit(3)
          .average(:points)&.round(2) || 0
  end

  private_class_method :assign_metrics, :driver_results, :calc_performance_index,
                       :calc_consistency_score, :calc_race_pace, :calc_quali_pace,
                       :calc_avg_finish, :calc_recent_form
end
