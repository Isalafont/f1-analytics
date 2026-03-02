# frozen_string_literal: true

# Backward-compatibility wrapper → delegates to F1::OpenF1Client
# Ergast API is dead. Use F1::OpenF1Client directly for new code.
class F1ApiClient
  def initialize(season = Date.current.year)
    @season = season
    @client = F1::OpenF1Client.new
  end

  def fetch_races
    @client.sessions(year: @season).map { |s| map_session(s) }
  end

  def fetch_race_results(round)
    session_key = @client.session_key_for_round(year: @season, round: round)
    return [] unless session_key

    @client.race_results(session_key: session_key)
  end

  private

  def map_session(session)
    {
      name: "#{session["country_name"]} Grand Prix",
      circuit: session["circuit_short_name"],
      country: session["country_name"],
      round: session["round_number"],
      season: @season,
      date: session["date_start"]&.then { |d| Date.parse(d) }
    }
  end
end
