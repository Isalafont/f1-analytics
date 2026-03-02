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
  end
end
