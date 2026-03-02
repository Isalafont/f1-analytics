# app/models/result.rb
class Result < ApplicationRecord
  belongs_to :race
  belongs_to :driver

  validates :race, presence: true
  validates :driver, presence: true
  validates :race_id, uniqueness: { scope: :driver_id }

  scope :finished, -> { where(status: 'Finished') }
  scope :dnf, -> { where.not(status: 'Finished') }
  scope :points_scorers, -> { where('points > 0').order(points: :desc) }
  scope :podium, -> { where(final_position: [1, 2, 3]).order(:final_position) }

  after_save :update_metrics

  def positions_gained
    return nil unless grid_position && final_position
    grid_position - final_position
  end

  def finished?
    status == 'Finished'
  end

  def scored_points?
    points > 0
  end

  def result_summary
    if finished?
      "P#{final_position} (#{points} pts)"
    else
      "#{status} (0 pts)"
    end
  end

  private

  def update_metrics
    MetricsCalculatorJob.perform_later(driver.id, race.id)
  end
end
