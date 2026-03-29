# frozen_string_literal: true

# app/models/driver_news.rb
class DriverNews < ApplicationRecord
  belongs_to :driver, optional: true  # Null if general news

  validates :category, presence: true
  validates :title, presence: true
  validates :event_date, presence: true

  enum :category, {
    injury: "injury",                 # Injuries, fitness
    penalty: "penalty",               # Grid penalties, time penalties
    contract: "contract",             # Contract news, moves
    engineer_change: "engineer_change", # Race engineer changes
    personal: "personal",             # Personal issues affecting performance
    form: "form",                     # Form updates, confidence
    other: "other"
  }, prefix: true

  enum :impact_level, {
    high: "high",
    medium: "medium",
    low: "low"
  }, prefix: true

  scope :recent, -> { where(event_date: 30.days.ago..).order(event_date: :desc) }
  scope :high_impact, -> { where(impact_level: "high") }
  scope :affects_performance, -> { where(affects_performance: true) }
  scope :by_date, -> { order(event_date: :desc) }

  def recent?
    event_date >= 7.days.ago
  end

  def critical?
    impact_level == "high" && affects_performance?
  end
end
