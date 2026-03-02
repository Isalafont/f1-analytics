# lib/tasks/f1_data.rake
namespace :f1 do
  desc "Import all races for current season"
  task import_races: :environment do
    season = ENV['SEASON']&.to_i || Date.current.year
    client = F1ApiClient.new(season)
    
    puts "Fetching races for #{season}..."
    races_data = client.fetch_races
    
    races_data.each do |race_data|
      race = Race.find_or_create_by!(season: race_data[:season], round: race_data[:round]) do |r|
        r.name = race_data[:name]
        r.circuit = race_data[:circuit]
        r.country = race_data[:country]
        r.date = race_data[:date]
        r.time = race_data[:time]
      end
      
      puts "  ✓ Round #{race.round}: #{race.name} - #{race.date}"
    end
    
    puts "✅ Imported #{races_data.size} races for #{season}"
  end

  desc "Fetch results for a specific race"
  task :fetch_race_results, [:round] => :environment do |t, args|
    season = ENV['SEASON']&.to_i || Date.current.year
    round = args[:round]&.to_i
    
    unless round
      puts "❌ Usage: rake f1:fetch_race_results[ROUND] SEASON=2025"
      exit 1
    end
    
    race = Race.find_by(season: season, round: round)
    unless race
      puts "❌ Race not found: Season #{season}, Round #{round}"
      puts "Run 'rake f1:import_races' first"
      exit 1
    end
    
    puts "Fetching results for #{race.name}..."
    FetchRaceResultsJob.perform_now(race.id)
    puts "✅ Results fetched and metrics calculated"
  end

  desc "Fetch results for all completed races"
  task fetch_all_results: :environment do
    season = ENV['SEASON']&.to_i || Date.current.year
    
    # Only fetch races that have already occurred
    races = Race.for_season(season).where('date <= ?', Date.current).order(:round)
    
    puts "Fetching results for #{races.count} races in #{season}..."
    races.each do |race|
      next if race.status_completed?
      
      puts "  Fetching Round #{race.round}: #{race.name}..."
      begin
        FetchRaceResultsJob.perform_now(race.id)
        puts "    ✓ Done"
      rescue StandardError => e
        puts "    ❌ Error: #{e.message}"
      end
    end
    
    puts "✅ All results fetched"
  end

  desc "Recalculate all metrics"
  task recalculate_metrics: :environment do
    season = ENV['SEASON']&.to_i || Date.current.year
    drivers = Driver.for_season(season)
    
    puts "Recalculating metrics for #{drivers.count} drivers..."
    drivers.each do |driver|
      CalculateMetricsJob.perform_now(driver.id)
      print "."
    end
    
    puts "\n✅ All metrics recalculated"
  end

  desc "Seed 2025 season data (teams and drivers)"
  task seed_2025: :environment do
    season = 2025
    
    teams_data = [
      { name: 'Red Bull Racing', constructor: 'Red Bull', color_primary: '#3671C6', color_secondary: '#FFFFFF' },
      { name: 'Ferrari', constructor: 'Ferrari', color_primary: '#E8002D', color_secondary: '#FFFFFF' },
      { name: 'Mercedes', constructor: 'Mercedes', color_primary: '#27F4D2', color_secondary: '#000000' },
      { name: 'McLaren', constructor: 'McLaren', color_primary: '#FF8000', color_secondary: '#000000' },
      { name: 'Aston Martin', constructor: 'Aston Martin', color_primary: '#229971', color_secondary: '#FFFFFF' },
      { name: 'Alpine', constructor: 'Alpine', color_primary: '#FF87BC', color_secondary: '#FFFFFF' },
      { name: 'Williams', constructor: 'Williams', color_primary: '#64C4FF', color_secondary: '#FFFFFF' },
      { name: 'Haas F1 Team', constructor: 'Haas', color_primary: '#B6BABD', color_secondary: '#000000' },
      { name: 'RB', constructor: 'RB', color_primary: '#6692FF', color_secondary: '#FFFFFF' },
      { name: 'Sauber', constructor: 'Sauber', color_primary: '#52E252', color_secondary: '#000000' }
    ]
    
    drivers_data = [
      { first_name: 'Max', last_name: 'Verstappen', code: 'VER', number: 1, team: 'Red Bull Racing', nationality: 'Dutch' },
      { first_name: 'Sergio', last_name: 'Pérez', code: 'PER', number: 11, team: 'Red Bull Racing', nationality: 'Mexican' },
      { first_name: 'Charles', last_name: 'Leclerc', code: 'LEC', number: 16, team: 'Ferrari', nationality: 'Monégasque' },
      { first_name: 'Lewis', last_name: 'Hamilton', code: 'HAM', number: 44, team: 'Ferrari', nationality: 'British' },
      { first_name: 'George', last_name: 'Russell', code: 'RUS', number: 63, team: 'Mercedes', nationality: 'British' },
      { first_name: 'Andrea', last_name: 'Kimi Antonelli', code: 'ANT', number: 12, team: 'Mercedes', nationality: 'Italian' },
      { first_name: 'Lando', last_name: 'Norris', code: 'NOR', number: 4, team: 'McLaren', nationality: 'British' },
      { first_name: 'Oscar', last_name: 'Piastri', code: 'PIA', number: 81, team: 'McLaren', nationality: 'Australian' },
      { first_name: 'Fernando', last_name: 'Alonso', code: 'ALO', number: 14, team: 'Aston Martin', nationality: 'Spanish' },
      { first_name: 'Lance', last_name: 'Stroll', code: 'STR', number: 18, team: 'Aston Martin', nationality: 'Canadian' },
      { first_name: 'Pierre', last_name: 'Gasly', code: 'GAS', number: 10, team: 'Alpine', nationality: 'French' },
      { first_name: 'Jack', last_name: 'Doohan', code: 'DOO', number: 7, team: 'Alpine', nationality: 'Australian' },
      { first_name: 'Alex', last_name: 'Albon', code: 'ALB', number: 23, team: 'Williams', nationality: 'Thai' },
      { first_name: 'Carlos', last_name: 'Sainz', code: 'SAI', number: 55, team: 'Williams', nationality: 'Spanish' },
      { first_name: 'Oliver', last_name: 'Bearman', code: 'BEA', number: 87, team: 'Haas F1 Team', nationality: 'British' },
      { first_name: 'Esteban', last_name: 'Ocon', code: 'OCO', number: 31, team: 'Haas F1 Team', nationality: 'French' },
      { first_name: 'Yuki', last_name: 'Tsunoda', code: 'TSU', number: 22, team: 'RB', nationality: 'Japanese' },
      { first_name: 'Isack', last_name: 'Hadjar', code: 'HAD', number: 6, team: 'RB', nationality: 'French' },
      { first_name: 'Nico', last_name: 'Hülkenberg', code: 'HUL', number: 27, team: 'Sauber', nationality: 'German' },
      { first_name: 'Gabriel', last_name: 'Bortoleto', code: 'BOR', number: 5, team: 'Sauber', nationality: 'Brazilian' }
    ]
    
    puts "Seeding 2025 season data..."
    
    # Create teams
    teams_data.each do |team_data|
      team = Team.find_or_create_by!(name: team_data[:name], season: season) do |t|
        t.constructor = team_data[:constructor]
        t.color_primary = team_data[:color_primary]
        t.color_secondary = team_data[:color_secondary]
      end
      puts "  ✓ Team: #{team.name}"
    end
    
    # Create drivers
    drivers_data.each do |driver_data|
      team = Team.find_by!(name: driver_data[:team], season: season)
      driver = Driver.find_or_create_by!(
        code: driver_data[:code],
        season: season
      ) do |d|
        d.first_name = driver_data[:first_name]
        d.last_name = driver_data[:last_name]
        d.number = driver_data[:number]
        d.nationality = driver_data[:nationality]
        d.team = team
      end
      puts "  ✓ Driver: #{driver.display_name} (#{team.name})"
    end
    
    puts "✅ 2025 season data seeded"
  end
end
