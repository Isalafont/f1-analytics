# frozen_string_literal: true

# app/services/f1/open_f1_client.rb
# Client OpenF1 API - remplace Ergast (morte fin 2024)
# Doc: https://openf1.org | Documenté par Data ✨ | Implémenté par Bender 🤖

require "net/http"
require "json"

module F1
  class OpenF1Client
    include F1::Constants
    include F1::MetricsCalculator

    BASE_URL = "https://api.openf1.org/v1"
    RATE_LIMIT_DELAY = 0.35 # sec entre requêtes (rate limit: 3 req/s)

    # ─────────────────────────────────────────────
    # SESSIONS
    # ─────────────────────────────────────────────

    def sessions(year:, session_name: "Race")
      get("/sessions", year: year, session_name: session_name)
    end

    def session_key_for_round(year:, round:)
      return F1::Constants::KNOWN_SESSIONS_2025[round][:session_key] if known_session?(year, round)

      sessions(year: year, session_name: "Race")
        .sort_by { |s| s["date_start"] }
        .dig(round - 1, "session_key")
    end

    # ─────────────────────────────────────────────
    # RÉSULTATS
    # ─────────────────────────────────────────────

    def race_results(session_key:)
      final_positions = extract_final_positions(session_key)
      driver_index = drivers(session_key: session_key).index_by { |d| d["driver_number"] }

      final_positions
        .map { |number, pos| build_result(number, pos, driver_index, session_key) }
        .sort_by { |r| r[:final_position] || 99 }
    end

    def grid_positions(qualifying_session_key:)
      positions(session_key: qualifying_session_key)
        .group_by { |p| p["driver_number"] }
        .transform_values { |pos| pos.min_by { |p| p["position"] }["position"] }
    end

    def positions(session_key:, driver_number: nil)
      params = { session_key: session_key }
      params[:driver_number] = driver_number if driver_number
      get("/position", **params)
    end

    # ─────────────────────────────────────────────
    # DONNÉES BRUTES
    # ─────────────────────────────────────────────

    def laps(session_key:, driver_number:)
      get("/laps", session_key: session_key, driver_number: driver_number)
    end

    def pit_stops(session_key:, driver_number:)
      get("/pit", session_key: session_key, driver_number: driver_number)
    end

    def drivers(session_key:)
      get("/drivers", session_key: session_key)
    end

    def weather(session_key:)
      get("/weather", session_key: session_key)
    end

    def race_control(session_key:)
      get("/race_control", session_key: session_key)
    end

    private

    def known_session?(year, round)
      year == 2025 && F1::Constants::KNOWN_SESSIONS_2025[round]
    end

    def extract_final_positions(session_key)
      positions(session_key: session_key)
        .group_by { |p| p["driver_number"] }
        .transform_values { |pos| pos.max_by { |p| p["date"] } }
    end

    def build_result(driver_number, position_data, driver_index, session_key)
      driver = driver_index[driver_number] || {}
      final_pos = position_data["position"]

      { driver_number: driver_number, driver_code: driver["name_acronym"],
        driver_first_name: driver["first_name"], driver_last_name: driver["last_name"],
        team_name: driver["team_name"], final_position: final_pos,
        points: F1::Constants::POINTS_MAP[final_pos] || 0, session_key: session_key }
    end

    def final_position(session_key:, driver_number:)
      positions(session_key: session_key, driver_number: driver_number)
        .max_by { |p| p["date"] }
        &.dig("position")
    end

    def get(endpoint, **params)
      sleep(RATE_LIMIT_DELAY)
      parse_response(Net::HTTP.get_response(build_uri(endpoint, params)), endpoint)
    end

    def build_uri(endpoint, params)
      uri = URI("#{BASE_URL}#{endpoint}")
      uri.query = URI.encode_www_form(params) unless params.empty?
      uri
    end

    def parse_response(response, endpoint)
      Rails.logger.error("OpenF1 #{response.code}: #{endpoint}") unless response.is_a?(Net::HTTPSuccess)
      return [] unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body)
    rescue JSON::ParserError => e
      Rails.logger.error("OpenF1 JSON parse error: #{e.message}")
      []
    end
  end
end
