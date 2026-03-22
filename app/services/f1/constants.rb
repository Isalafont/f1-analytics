# frozen_string_literal: true

module F1
  module Constants
    POINTS_MAP = {
      1 => 25, 2 => 18, 3 => 15, 4 => 12, 5 => 10,
      6 => 8,  7 => 6,  8 => 4,  9 => 2,  10 => 1
    }.freeze

    KNOWN_SESSIONS_2025 = {
      1 => { session_key: 9_693,  circuit: "Melbourne", country: "Australia",    date: "2025-03-16" },
      2 => { session_key: 9_998,  circuit: "Shanghai",  country: "China",        date: "2025-03-23" },
      3 => { session_key: 10_006, circuit: "Suzuka",    country: "Japan",        date: "2025-04-06" },
      4 => { session_key: 10_014, circuit: "Sakhir",    country: "Bahrain",      date: "2025-04-13" },
      5 => { session_key: 10_022, circuit: "Jeddah",    country: "Saudi Arabia", date: "2025-04-20" },
      6 => { session_key: 10_033, circuit: "Miami",     country: "USA",          date: "2025-05-04" }
    }.freeze

    # Sessions 2026 — récupérés via OpenF1 le 2026-03-21 par Bender 🤖
    # Source: GET https://api.openf1.org/v1/sessions?year=2026&session_name=Race
    # NOTE: R4 Bahrain + R5 Saudi Arabia ont des session_keys OpenF1 mais sont annulés
    #       → session_key_for_round retourne nil si status == "cancelled"
    # NOTE: R16 = Madrid (nouveau circuit "Madring"), pas Barcelona
    # NOTE: R18-R24 session_keys confirmés dans l'API le 2026-03-21
    KNOWN_SESSIONS_2026 = {
      1 => { session_key: 11_234, circuit: "Melbourne",         country: "Australia",
             date: "2026-03-08", status: "completed" },
      2 => { session_key: 11_245, circuit: "Shanghai",          country: "China",
             date: "2026-03-15", status: "completed" },
      3 => { session_key: 11_253, circuit: "Suzuka",            country: "Japan",
             date: "2026-03-29", status: "scheduled" },
      4 => { session_key: 11_261, circuit: "Sakhir",            country: "Bahrain",
             date: "2026-04-12", status: "cancelled" },
      5 => { session_key: 11_269, circuit: "Jeddah",            country: "Saudi Arabia",
             date: "2026-04-19", status: "cancelled" },
      6 => { session_key: 11_280, circuit: "Miami",             country: "USA",
             date: "2026-05-03", status: "scheduled" },
      7 => { session_key: 11_291, circuit: "Montreal",          country: "Canada",
             date: "2026-05-24", status: "scheduled" },
      8 => { session_key: 11_299, circuit: "Monte Carlo",       country: "Monaco",
             date: "2026-06-07", status: "scheduled" },
      9 => { session_key: 11_307, circuit: "Catalunya",         country: "Spain",
             date: "2026-06-14", status: "scheduled" },
      10 => { session_key: 11_315, circuit: "Spielberg",         country: "Austria",
              date: "2026-06-28", status: "scheduled" },
      11 => { session_key: 11_326, circuit: "Silverstone",       country: "Great Britain",
              date: "2026-07-05", status: "scheduled" },
      12 => { session_key: 11_334, circuit: "Spa-Francorchamps", country: "Belgium",
              date: "2026-07-19", status: "scheduled" },
      13 => { session_key: 11_342, circuit: "Hungaroring",       country: "Hungary",
              date: "2026-07-26", status: "scheduled" },
      14 => { session_key: 11_353, circuit: "Zandvoort",         country: "Netherlands",
              date: "2026-08-23", status: "scheduled" },
      15 => { session_key: 11_361, circuit: "Monza",             country: "Italy",
              date: "2026-09-06", status: "scheduled" },
      16 => { session_key: 11_369, circuit: "Madring",           country: "Spain",
              date: "2026-09-13", status: "scheduled" }, # Madrid (nouveau circuit)
      17 => { session_key: 11_377, circuit: "Baku",              country: "Azerbaijan",
              date: "2026-09-26", status: "scheduled" },
      18 => { session_key: 11_388, circuit: "Marina Bay",        country: "Singapore",
              date: "2026-10-11", status: "scheduled" },
      19 => { session_key: 11_396, circuit: "COTA",              country: "USA",
              date: "2026-10-25", status: "scheduled" },
      20 => { session_key: 11_404, circuit: "Mexico City",       country: "Mexico",
              date: "2026-11-01", status: "scheduled" },
      21 => { session_key: 11_412, circuit: "Interlagos",        country: "Brazil",
              date: "2026-11-08", status: "scheduled" },
      22 => { session_key: 11_420, circuit: "Las Vegas",         country: "USA",
              date: "2026-11-21", status: "scheduled" },
      23 => { session_key: 11_428, circuit: "Losail",            country: "Qatar",
              date: "2026-11-29", status: "scheduled" },
      24 => { session_key: 11_436, circuit: "Yas Marina",        country: "UAE",
              date: "2026-12-06", status: "scheduled" }
    }.freeze
  end
end
