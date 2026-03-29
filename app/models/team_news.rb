# frozen_string_literal: true

# app/models/team_news.rb
class TeamNews < ApplicationRecord
  belongs_to :team, optional: true # Null if general news

  validates :category, presence: true
  validates :title, presence: true
  validates :event_date, presence: true

  enum :category, {
    technical: "technical",           # Upgrades, developments
    personnel: "personnel",           # Director, engineer changes
    strategy: "strategy",             # Strategy changes
    penalty: "penalty",               # Team penalties
    regulation: "regulation",         # Regulation impacts
    financial: "financial",           # Budget cap, sponsorship
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
