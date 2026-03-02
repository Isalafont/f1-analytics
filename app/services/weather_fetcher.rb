# app/services/weather_fetcher.rb
require "net/http"
require "json"

class WeatherFetcher
  # OpenF1 API for weather data
  # Alternatively, can scrape F1.com or use manual input

  def initialize(race)
    @race = race
  end

  # Fetch weather for all sessions of a race
  def fetch_all_sessions
    sessions = %w[FP1 FP2 FP3 Qualifying Race]

    sessions.each do |session|
      fetch_session_weather(session)
    end
  end

  # Fetch weather for specific session
  def fetch_session_weather(session_type)
    # TODO: Implement actual API call or scraping
    # For now, this is a stub that would need to be implemented
    # with real data source (OpenF1 API, F1.com scraping, or manual input)

    # Example structure for manual input:
    # weather = WeatherCondition.find_or_create_by(race: @race, session_type: session_type)
    # weather.update(
    #   condition: 'Dry',
    #   air_temp: 25.5,
    #   track_temp: 38.2,
    #   humidity: 45,
    #   wind_speed: 12.5,
    #   wind_direction: 'NW'
    # )

    Rails.logger.info "Weather fetch for #{@race.name} - #{session_type} (implement data source)"
  end

  # Manual entry helper (for admin interface)
  def self.create_manual(race, session_type, attributes = {})
    WeatherCondition.find_or_create_by(race: race, session_type: session_type) do |weather|
      weather.condition = attributes[:condition]
      weather.air_temp = attributes[:air_temp]
      weather.track_temp = attributes[:track_temp]
      weather.humidity = attributes[:humidity]
      weather.wind_speed = attributes[:wind_speed]
      weather.wind_direction = attributes[:wind_direction]
      weather.rainfall = attributes[:rainfall]
      weather.notes = attributes[:notes]
    end
  end
end
