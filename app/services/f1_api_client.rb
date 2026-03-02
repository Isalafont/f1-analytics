# app/services/f1_api_client.rb
require "net/http"
require "json"

class F1ApiClient
  BASE_URL = "https://ergast.com/api/f1"

  def initialize(season = Date.current.year)
    @season = season
  end

  # Fetch all races for the season
  def fetch_races
    response = get("/#{@season}.json")
    races_data = response.dig("MRData", "RaceTable", "Races") || []

    races_data.map do |race_data|
      {
        name: race_data["raceName"],
        circuit: race_data.dig("Circuit", "circuitName"),
        country: race_data.dig("Circuit", "Location", "country"),
        round: race_data["round"].to_i,
        season: @season,
        date: Date.parse(race_data["date"]),
        time: race_data["time"] ? Time.parse(race_data["time"]) : nil
      }
    end
  end

  # Fetch results for a specific race
  def fetch_race_results(round)
    response = get("/#{@season}/#{round}/results.json")
    results_data = response.dig("MRData", "RaceTable", "Races", 0, "Results") || []

    results_data.map do |result|
      {
        driver_code: result.dig("Driver", "code"),
        driver_first_name: result.dig("Driver", "givenName"),
        driver_last_name: result.dig("Driver", "familyName"),
        driver_number: result.dig("Driver", "permanentNumber")&.to_i,
        driver_nationality: result.dig("Driver", "nationality"),
        team_name: result.dig("Constructor", "name"),
        grid_position: result["grid"].to_i,
        final_position: result["position"]&.to_i,
        points: result["points"].to_f.to_i,
        status: result["status"],
        laps_completed: result["laps"]&.to_i,
        fastest_lap_time: result.dig("FastestLap", "Time", "time"),
        fastest_lap_rank: result.dig("FastestLap", "rank")&.to_i
      }
    end
  end

  # Fetch qualifying results
  def fetch_qualifying_results(round)
    response = get("/#{@season}/#{round}/qualifying.json")
    quali_data = response.dig("MRData", "RaceTable", "Races", 0, "QualifyingResults") || []

    quali_data.map do |quali|
      {
        driver_code: quali.dig("Driver", "code"),
        grid_position: quali["position"].to_i,
        q1_time: quali.dig("Q1"),
        q2_time: quali.dig("Q2"),
        q3_time: quali.dig("Q3")
      }
    end
  end

  # Fetch current season standings
  def fetch_driver_standings
    response = get("/#{@season}/driverStandings.json")
    standings_data = response.dig("MRData", "StandingsTable", "StandingsLists", 0, "DriverStandings") || []

    standings_data.map do |standing|
      {
        position: standing["position"].to_i,
        points: standing["points"].to_f.to_i,
        wins: standing["wins"].to_i,
        driver_code: standing.dig("Driver", "code"),
        driver_first_name: standing.dig("Driver", "givenName"),
        driver_last_name: standing.dig("Driver", "familyName"),
        team_name: standing.dig("Constructors", 0, "name")
      }
    end
  end

  # Fetch constructor standings
  def fetch_constructor_standings
    response = get("/#{@season}/constructorStandings.json")
    standings_data = response.dig("MRData", "StandingsTable", "StandingsLists", 0, "ConstructorStandings") || []

    standings_data.map do |standing|
      {
        position: standing["position"].to_i,
        points: standing["points"].to_f.to_i,
        wins: standing["wins"].to_i,
        team_name: standing.dig("Constructor", "name"),
        team_id: standing.dig("Constructor", "constructorId")
      }
    end
  end

  private

  def get(path)
    uri = URI("#{BASE_URL}#{path}")
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  rescue StandardError => e
    Rails.logger.error "F1 API Error: #{e.message}"
    {}
  end
end
