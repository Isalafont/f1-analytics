# frozen_string_literal: true

module F1
  # Calcul des métriques custom F1 à partir des données OpenF1
  # Utilisé par OpenF1Client
  module MetricsCalculator
    # Race Pace = positions gagnées (grille → arrivée)
    # Positif = a progressé, Négatif = a reculé
    def race_pace(session_key:, qualifying_session_key:, driver_number:)
      grid = grid_positions(qualifying_session_key: qualifying_session_key)[driver_number]
      final = final_position(session_key: session_key, driver_number: driver_number)
      return nil unless grid && final

      grid - final
    end

    # Consistency Score = inverse de la variance des temps au tour (0-100)
    # Plus le score est élevé, plus le pilote est régulier
    def consistency_score(session_key:, driver_number:)
      durations = valid_lap_durations(session_key: session_key, driver_number: driver_number)
      return nil if durations.length < 3

      std_dev = standard_deviation(durations)
      [100 - (std_dev * 10), 0].max.round(2)
    end

    private

    def valid_lap_durations(session_key:, driver_number:)
      laps(session_key: session_key, driver_number: driver_number)
        .reject { |l| l["is_pit_out_lap"] }
        .filter_map { |l| l["lap_duration"] }
        .select(&:positive?)
    end

    def standard_deviation(values)
      mean = values.sum.fdiv(values.length)
      variance = values.sum { |v| (v - mean)**2 }.fdiv(values.length)
      Math.sqrt(variance)
    end
  end
end
