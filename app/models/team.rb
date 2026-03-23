# frozen_string_literal: true

# app/models/team.rb
class Team < ApplicationRecord
  has_many :drivers, dependent: :restrict_with_error
  has_many :results, through: :drivers
  has_many :team_news, dependent: :destroy

  validates :name, presence: true
  validates :constructor, presence: true
  validates :season, presence: true, numericality: { only_integer: true }
  validates :name, uniqueness: { scope: :season }

  scope :active, -> { where(active: true) }
  scope :for_season, ->(season) { where(season: season) }
  scope :current_season, -> { for_season(Date.current.year) }

  # Clé CSS pour les tokens --f1-team-* (tailwind.config.js + application.css)
  # Utilisé dans les vues : style="background-color: var(--f1-team-<%= team.tailwind_key %>)"
  TAILWIND_KEY_MAP = {
    "Red Bull Racing" => "redbull",
    "Ferrari" => "ferrari",
    "McLaren" => "mclaren",
    "Mercedes" => "mercedes",
    "Aston Martin" => "astonmartin",
    "Alpine" => "alpine",
    "Haas" => "haas",
    "RB" => "rb",
    "Kick Sauber" => "sauber",
    "Williams" => "williams",
    "Audi" => "audi",
    "Cadillac" => "cadillac"
  }.freeze

  def tailwind_key
    TAILWIND_KEY_MAP.fetch(name, name.downcase.gsub(/\s+/, ""))
  end

  def full_name
    "#{name} (#{constructor})"
  end

  def driver_lineup
    drivers.active.order(:last_name)
  end

  def total_points
    results.sum(:points)
  end

  def recent_news
    team_news.recent.limit(5)
  end

  def critical_news
    team_news.high_impact.affects_performance.recent
  end
end
