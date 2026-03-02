# frozen_string_literal: true

# app/models/race.rb
class Race < ApplicationRecord
  has_many :results, dependent: :destroy
  has_many :drivers, through: :results
  has_many :metrics, dependent: :destroy
  has_many :weather_conditions, dependent: :destroy

  validates :name, presence: true
  validates :circuit, presence: true
  validates :round, presence: true, numericality: { only_integer: true }
  validates :season, presence: true, numericality: { only_integer: true }
  validates :date, presence: true
  validates :round, uniqueness: { scope: :season }

  enum :status, {
    scheduled: "scheduled",
    in_progress: "in_progress",
    completed: "completed",
    cancelled: "cancelled"
  }, prefix: true

  scope :for_season, ->(season) { where(season: season) }
  scope :current_season, -> { for_season(Date.current.year) }
  scope :upcoming, -> { where(status: "scheduled").where(date: Date.current..).order(:date) }
  scope :completed, -> { where(status: "completed").order(date: :desc) }
  scope :by_round, -> { order(:round) }

  def full_name
    "#{name} - Round #{round}"
  end

  def winner
    results.where(final_position: 1).first&.driver
  end

  def pole_sitter
    results.where(grid_position: 1).first&.driver
  end

  def podium
    results.where(final_position: [1, 2, 3]).order(:final_position).includes(:driver)
  end

  def fastest_lap_driver
    results.where(fastest_lap: true).first&.driver
  end

  def next_race
    Race.where(season: season).where("round > ?", round).order(:round).first
  end

  def previous_race
    Race.where(season: season).where(round: ...round).order(round: :desc).first
  end

  def race_weather
    weather_conditions.session_type_race.first
  end

  def qualifying_weather
    weather_conditions.session_type_qualifying.first
  end

  def was_wet_race?
    race_weather&.wet?
  end

  def was_wet_qualifying?
    qualifying_weather&.wet?
  end
end
