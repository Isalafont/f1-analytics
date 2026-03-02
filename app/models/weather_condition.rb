# app/models/weather_condition.rb
class WeatherCondition < ApplicationRecord
  belongs_to :race

  validates :race, presence: true
  validates :session_type, presence: true
  validates :race_id, uniqueness: { scope: :session_type }

  enum session_type: {
    fp1: 'FP1',
    fp2: 'FP2',
    fp3: 'FP3',
    qualifying: 'Qualifying',
    race: 'Race'
  }, _prefix: true

  enum condition: {
    dry: 'Dry',
    wet: 'Wet',
    mixed: 'Mixed',
    damp: 'Damp'
  }, _prefix: true

  scope :race_sessions, -> { where(session_type: 'Race') }
  scope :qualifying_sessions, -> { where(session_type: 'Qualifying') }
  scope :wet_conditions, -> { where(condition: ['Wet', 'Mixed', 'Damp']) }
  scope :dry_conditions, -> { where(condition: 'Dry') }

  def wet?
    %w[Wet Mixed Damp].include?(condition)
  end

  def extreme_temp?
    track_temp && (track_temp > 50 || track_temp < 10)
  end

  def high_wind?
    wind_speed && wind_speed > 20
  end

  def summary
    parts = [condition]
    parts << "Air: #{air_temp}°C" if air_temp
    parts << "Track: #{track_temp}°C" if track_temp
    parts << "Rain: #{rainfall}mm" if rainfall && rainfall > 0
    parts << "Wind: #{wind_speed}km/h #{wind_direction}" if wind_speed
    parts.join(', ')
  end
end
