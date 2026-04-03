# frozen_string_literal: true

# Seeds F1 Analytics — Saison 2026
# Mis à jour: 2026-03-15 par Bender 🤖
# Changements vs 2025:
#   - Hamilton: Mercedes → Ferrari
#   - Antonelli: nouveau chez Mercedes (remplace Hamilton)
#   - Hadjar: nouveau chez Red Bull (remplace Tsunoda)
#   - Colapinto: Alpine (confirmé full-time)
#   - Bearman: Haas (confirmé full-time)
#   - Lindblad: Racing Bulls (rookie 2026)
#   - Sainz: Ferrari → Williams
#   - Bottas/Hülkenberg: Sauber → Audi (nouveau constructeur)
#   - Pérez: Red Bull → Cadillac (nouveau constructeur)
#   - Calendrier: 24 rounds, Bahrain + Saudi Arabia annulés → 22 courses effectives
#
# IMPORTANT: Isa doit valider avant rails db:seed en prod

SEASON = 2026

Rails.logger.info "🏎️  Seeding F1 #{SEASON}..."

# ─────────────────────────────────────────────
# TEAMS (11 constructeurs 2026)
# ─────────────────────────────────────────────

Rails.logger.info "  → Teams..."

teams_data = [
  { name: "McLaren",       constructor: "McLaren",       color_primary: "#FF8000", color_secondary: "#000000" },
  { name: "Ferrari",       constructor: "Ferrari",       color_primary: "#E8002D", color_secondary: "#FFFFFF" },
  { name: "Red Bull",      constructor: "Red Bull",      color_primary: "#3671C6", color_secondary: "#FFD700" },
  { name: "Mercedes",      constructor: "Mercedes",      color_primary: "#27F4D2", color_secondary: "#000000" },
  { name: "Aston Martin",  constructor: "Aston Martin",  color_primary: "#229971", color_secondary: "#FFFFFF" },
  { name: "Alpine",        constructor: "Alpine",        color_primary: "#FF87BC", color_secondary: "#0090FF" },
  { name: "Haas",          constructor: "Haas",          color_primary: "#E8002D", color_secondary: "#FFFFFF" },
  { name: "Racing Bulls",  constructor: "Racing Bulls",  color_primary: "#6692FF", color_secondary: "#FFFFFF" },
  { name: "Williams",      constructor: "Williams",      color_primary: "#64C4FF", color_secondary: "#FFFFFF" },
  { name: "Audi",          constructor: "Audi",          color_primary: "#BB0000", color_secondary: "#FFFFFF" }, # ex-Sauber
  { name: "Cadillac",      constructor: "Cadillac",      color_primary: "#004EFF", color_secondary: "#FFFFFF" }  # nouveau
]

teams = teams_data.each_with_object({}) do |attrs, hash|
  team = Team.find_or_create_by!(name: attrs[:name], season: SEASON) do |t|
    t.constructor    = attrs[:constructor]
    t.color_primary  = attrs[:color_primary]
    t.color_secondary = attrs[:color_secondary]
    t.active = true
  end
  hash[attrs[:name]] = team
end

Rails.logger.info "     #{teams.size} teams OK"

# ─────────────────────────────────────────────
# DRIVERS (22 pilotes 2026)
# ─────────────────────────────────────────────

Rails.logger.info "  → Drivers..."

drivers_data = [
  # McLaren
  { first_name: "Lando",    last_name: "Norris",     number: 1,  code: "NOR", nationality: "British", team: "McLaren" }, # #1 = champion 2025
  { first_name: "Oscar",    last_name: "Piastri",    number: 81, code: "PIA", nationality: "Australian",
    team: "McLaren" },
  # Ferrari
  { first_name: "Charles",  last_name: "Leclerc",    number: 16, code: "LEC", nationality: "Monégasque",
    team: "Ferrari" },
  { first_name: "Lewis",    last_name: "Hamilton",   number: 44, code: "HAM", nationality: "British",    team: "Ferrari" }, # ← Ferrari en 2026!
  # Red Bull
  { first_name: "Max",      last_name: "Verstappen", number: 3,  code: "VER", nationality: "Dutch",      team: "Red Bull" }, # #3 confirmé OpenF1 2026
  { first_name: "Isack",    last_name: "Hadjar",     number: 6,  code: "HAD", nationality: "French",     team: "Red Bull" }, # ← nouveau (ex-Racing Bulls)
  # Mercedes
  { first_name: "George",   last_name: "Russell",    number: 63, code: "RUS", nationality: "British",
    team: "Mercedes" },
  { first_name: "Kimi",     last_name: "Antonelli",  number: 12, code: "ANT", nationality: "Italian", team: "Mercedes" }, # ← nouveau (remplace Hamilton)
  # Aston Martin
  { first_name: "Fernando", last_name: "Alonso",     number: 14, code: "ALO", nationality: "Spanish",
    team: "Aston Martin" },
  { first_name: "Lance",    last_name: "Stroll",     number: 18, code: "STR", nationality: "Canadian",
    team: "Aston Martin" },
  # Alpine
  { first_name: "Pierre",   last_name: "Gasly",      number: 10, code: "GAS", nationality: "French",
    team: "Alpine" },
  { first_name: "Franco",   last_name: "Colapinto",  number: 43, code: "COL", nationality: "Argentinian", team: "Alpine" }, # ← confirmé full-time
  # Haas
  { first_name: "Esteban",  last_name: "Ocon",       number: 31, code: "OCO", nationality: "French",     team: "Haas" }, # ← ex-Alpine
  { first_name: "Oliver",   last_name: "Bearman",    number: 87, code: "BEA", nationality: "British",    team: "Haas" }, # ← confirmé full-time
  # Racing Bulls
  { first_name: "Liam",     last_name: "Lawson",     number: 30, code: "LAW", nationality: "New Zealander",
    team: "Racing Bulls" },
  { first_name: "Arvid",    last_name: "Lindblad",   number: 41, code: "LIN", nationality: "British",    team: "Racing Bulls" }, # ← rookie 2026, #41 confirmé OpenF1
  # Williams
  { first_name: "Carlos",   last_name: "Sainz",      number: 55, code: "SAI", nationality: "Spanish",    team: "Williams" }, # ← ex-Ferrari
  { first_name: "Alex",     last_name: "Albon",      number: 23, code: "ALB", nationality: "Thai",
    team: "Williams" },
  # Audi (ex-Sauber)
  { first_name: "Nico",     last_name: "Hülkenberg", number: 27, code: "HUL", nationality: "German", team: "Audi" },
  { first_name: "Gabriel",  last_name: "Bortoleto",  number: 5,  code: "BOR", nationality: "Brazilian",  team: "Audi" },
  # Cadillac (nouveau)
  { first_name: "Sergio",   last_name: "Pérez",      number: 11, code: "PER", nationality: "Mexican",    team: "Cadillac" }, # ← ex-Red Bull
  { first_name: "Valtteri", last_name: "Bottas",     number: 77, code: "BOT", nationality: "Finnish",    team: "Cadillac" }  # ← ex-Audi/Sauber
]

drivers_data.each do |attrs|
  Driver.find_or_create_by!(code: attrs[:code], season: SEASON) do |d|
    d.first_name  = attrs[:first_name]
    d.last_name   = attrs[:last_name]
    d.number      = attrs[:number]
    d.nationality = attrs[:nationality]
    d.team        = teams[attrs[:team]]
    d.active      = true
  end
end

Rails.logger.info "     #{drivers_data.size} drivers OK"

# ─────────────────────────────────────────────
# RACES — Calendrier 2026 (24 rounds, 2 annulés)
# ─────────────────────────────────────────────

Rails.logger.info "  → Races..."

races_data = [
  # Données confirmées via OpenF1 API + formula1.com (2026-03-15)
  { round: 1,  name: "Australian Grand Prix",         circuit: "Albert Park",
    country: "Australia",    date: "2026-03-08", status: "completed" },
  { round: 2,  name: "Chinese Grand Prix",            circuit: "Shanghai International",
    country: "China",        date: "2026-03-15", status: "completed" },
  { round: 3,  name: "Japanese Grand Prix",           circuit: "Suzuka",
    country: "Japan",        date: "2026-03-29", status: "scheduled" },
  { round: 4,  name: "Bahrain Grand Prix",            circuit: "Bahrain International",         country: "Bahrain",      date: "2026-04-12", status: "cancelled" }, # ← ANNULÉ
  { round: 5,  name: "Saudi Arabian Grand Prix",      circuit: "Jeddah Corniche",               country: "Saudi Arabia", date: "2026-04-19", status: "cancelled" }, # ← ANNULÉ
  { round: 6,  name: "Miami Grand Prix",              circuit: "Miami International",
    country: "USA",          date: "2026-05-03", status: "scheduled" },
  { round: 7,  name: "Canadian Grand Prix",           circuit: "Circuit Gilles Villeneuve",
    country: "Canada",       date: "2026-05-24", status: "scheduled" },
  { round: 8,  name: "Monaco Grand Prix",             circuit: "Circuit de Monaco",
    country: "Monaco",       date: "2026-06-07", status: "scheduled" },
  { round: 9,  name: "Spanish Grand Prix",            circuit: "Circuit de Barcelona-Catalunya",
    country: "Spain", date: "2026-06-14", status: "scheduled" },
  { round: 10, name: "Austrian Grand Prix",           circuit: "Red Bull Ring",
    country: "Austria", date: "2026-06-28", status: "scheduled" },
  { round: 11, name: "British Grand Prix",            circuit: "Silverstone",
    country: "Great Britain", date: "2026-07-05", status: "scheduled" },
  { round: 12, name: "Belgian Grand Prix",            circuit: "Circuit de Spa-Francorchamps",
    country: "Belgium",      date: "2026-07-19", status: "scheduled" },
  { round: 13, name: "Hungarian Grand Prix",          circuit: "Hungaroring",
    country: "Hungary",      date: "2026-07-26", status: "scheduled" },
  { round: 14, name: "Dutch Grand Prix",              circuit: "Circuit Zandvoort",
    country: "Netherlands",  date: "2026-08-23", status: "scheduled" },
  { round: 15, name: "Italian Grand Prix",            circuit: "Autodromo Nazionale Monza",
    country: "Italy",        date: "2026-09-06", status: "scheduled" },
  { round: 16, name: "Madrid Grand Prix",             circuit: "Madring", country: "Spain", date: "2026-09-13", status: "scheduled" }, # Nouveau circuit Madrid
  { round: 17, name: "Azerbaijan Grand Prix",         circuit: "Baku City Circuit",
    country: "Azerbaijan",   date: "2026-09-26", status: "scheduled" },
  { round: 18, name: "Singapore Grand Prix",          circuit: "Marina Bay Street Circuit",
    country: "Singapore",    date: "2026-10-11", status: "scheduled" },
  { round: 19, name: "United States Grand Prix",      circuit: "Circuit of the Americas",
    country: "USA",          date: "2026-10-25", status: "scheduled" },
  { round: 20, name: "Mexico City Grand Prix",        circuit: "Autodromo Hermanos Rodriguez",
    country: "Mexico",       date: "2026-11-01", status: "scheduled" },
  { round: 21, name: "São Paulo Grand Prix",          circuit: "Autodromo Jose Carlos Pace",
    country: "Brazil",       date: "2026-11-08", status: "scheduled" },
  { round: 22, name: "Las Vegas Grand Prix",          circuit: "Las Vegas Strip Circuit",
    country: "USA",          date: "2026-11-21", status: "scheduled" },
  { round: 23, name: "Qatar Grand Prix",              circuit: "Losail International",
    country: "Qatar",        date: "2026-11-29", status: "scheduled" },
  { round: 24, name: "Abu Dhabi Grand Prix",          circuit: "Yas Marina",
    country: "UAE",          date: "2026-12-06", status: "scheduled" }
  # R4 + R5 "Called Off" = 22 courses effectives, 24 rounds au total (numérotation officielle conservée)
]

races_data.each do |attrs|
  Race.find_or_create_by!(season: SEASON, round: attrs[:round]) do |r|
    r.name    = attrs[:name]
    r.circuit = attrs[:circuit]
    r.country = attrs[:country]
    r.date    = Date.parse(attrs[:date])
    r.status  = attrs[:status]
  end
end

Rails.logger.info "     #{races_data.size} races seeded " \
                  "(#{races_data.count { |r| r[:status] == "cancelled" }} annulées)"
Rails.logger.info ""
Rails.logger.info "✅ Seeds F1 2026 OK — #{teams.size} teams, #{drivers_data.size} drivers, #{races_data.size} rounds"
Rails.logger.info "⚠️  Valider avec Isa avant rails db:seed en prod!"

# ─────────────────────────────────────────────
# RESULTS — R1 + R2 2026 (source: OpenF1 /v1/position, dernière entrée par pilote)
# Récupérés le 2026-03-22 par Bender 🤖
# R3 Japan (2026-03-29) pas encore disputé → pas seedé
# R4/R5 annulés → pas seedé
# ─────────────────────────────────────────────

Rails.logger.info "  → Results R1 + R2..."

def seed_results(race, results_data)
  results_data.each do |driver_number, final_position|
    driver = Driver.find_by(number: driver_number, season: SEASON)
    unless driver
      Rails.logger.warn "    ⚠️  Driver ##{driver_number} not found — skipping"
      next
    end

    points = F1::Constants::POINTS_MAP.fetch(final_position, 0)

    # find_or_initialize_by + assign_attributes + save! = upsert safe
    # Contrairement à find_or_create_by!, ceci met à jour les records existants
    # (fix bug #81 : seed tourné avant PR #60 → points = 0 non mis à jour)
    result = Result.find_or_initialize_by(race: race, driver: driver)
    result.assign_attributes(final_position: final_position, points: points, status: "Finished")
    result.save!
  end
end

# R1 — Australian GP (session_key 11234, 2026-03-08)
# Source: OpenF1 /v1/position — dernière position connue par driver_number
r1 = Race.find_by!(season: SEASON, round: 1)
r1_results = {
  63 => 1,  # Russell
  12 => 2,  # Antonelli
  16 => 3,  # Leclerc
  44 => 4,  # Hamilton
  1 => 5,  # Norris
  3 => 6,  # Verstappen
  87 => 7,  # Bearman
  41 => 8,  # Lindblad
  5 => 9, # Bortoleto
  10 => 10, # Gasly
  31 => 11, # Ocon
  23 => 12, # Albon
  30 => 13, # Lawson
  43 => 14, # Colapinto
  55 => 15, # Sainz
  11 => 16, # Pérez
  18 => 17, # Stroll
  14 => 18, # Alonso
  77 => 19, # Bottas
  6 => 20, # Hadjar
  81 => 21, # Piastri
  27 => 22  # Hülkenberg
}
seed_results(r1, r1_results)
Rails.logger.info "     R1 Australia: #{r1_results.size} results OK"

# R2 — Chinese GP (session_key 11245, 2026-03-15)
r2 = Race.find_by!(season: SEASON, round: 2)
r2_results = {
  12 => 1,  # Antonelli
  63 => 2,  # Russell
  44 => 3,  # Hamilton
  16 => 4,  # Leclerc
  87 => 5,  # Bearman
  10 => 6,  # Gasly
  30 => 7,  # Lawson
  6 => 8, # Hadjar
  55 => 9,  # Sainz
  43 => 10, # Colapinto
  27 => 11, # Hülkenberg
  41 => 12, # Lindblad
  77 => 13, # Bottas
  31 => 14, # Ocon
  11 => 15, # Pérez
  3 => 16, # Verstappen
  14 => 17, # Alonso
  18 => 18, # Stroll
  81 => 19, # Piastri
  1 => 20, # Norris
  5 => 21, # Bortoleto
  23 => 22 # Albon
}
seed_results(r2, r2_results)
Rails.logger.info "     R2 China: #{r2_results.size} results OK"

Rails.logger.info ""
Rails.logger.info "✅ Results seedés : R1 Australian GP + R2 Chinese GP (#{r1_results.size + r2_results.size} entrées)"
