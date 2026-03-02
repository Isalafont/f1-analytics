# lib/tasks/f1_news.rake
namespace :f1 do
  namespace :news do
    desc "Add team news manually"
    task :add_team, [:team_name, :category, :title] => :environment do |t, args|
      team = Team.find_by(name: args[:team_name], season: Date.current.year)
      
      unless team
        puts "❌ Team not found: #{args[:team_name]}"
        exit 1
      end
      
      puts "Adding news for #{team.name}..."
      puts "Category: #{args[:category]}"
      puts "Title: #{args[:title]}"
      puts "Description (press Enter when done):"
      description = STDIN.gets.chomp
      
      print "Impact level (high/medium/low): "
      impact_level = STDIN.gets.chomp
      
      print "Affects performance? (y/n): "
      affects_perf = STDIN.gets.chomp.downcase == 'y'
      
      print "Event date (YYYY-MM-DD, default today): "
      date_input = STDIN.gets.chomp
      event_date = date_input.empty? ? Date.current : Date.parse(date_input)
      
      news = TeamNews.create!(
        team: team,
        category: args[:category],
        title: args[:title],
        description: description,
        impact_level: impact_level,
        affects_performance: affects_perf,
        event_date: event_date
      )
      
      puts "✅ Team news created (ID: #{news.id})"
    end

    desc "Add driver news manually"
    task :add_driver, [:driver_code, :category, :title] => :environment do |t, args|
      driver = Driver.find_by(code: args[:driver_code], season: Date.current.year)
      
      unless driver
        puts "❌ Driver not found: #{args[:driver_code]}"
        exit 1
      end
      
      puts "Adding news for #{driver.display_name}..."
      puts "Category: #{args[:category]}"
      puts "Title: #{args[:title]}"
      puts "Description (press Enter when done):"
      description = STDIN.gets.chomp
      
      print "Impact level (high/medium/low): "
      impact_level = STDIN.gets.chomp
      
      print "Affects performance? (y/n): "
      affects_perf = STDIN.gets.chomp.downcase == 'y'
      
      print "Event date (YYYY-MM-DD, default today): "
      date_input = STDIN.gets.chomp
      event_date = date_input.empty? ? Date.current : Date.parse(date_input)
      
      news = DriverNews.create!(
        driver: driver,
        category: args[:category],
        title: args[:title],
        description: description,
        impact_level: impact_level,
        affects_performance: affects_perf,
        event_date: event_date
      )
      
      puts "✅ Driver news created (ID: #{news.id})"
    end

    desc "List recent critical news"
    task list_critical: :environment do
      puts "\n🚨 CRITICAL TEAM NEWS:\n"
      TeamNews.high_impact.affects_performance.recent.each do |news|
        puts "  [#{news.event_date}] #{news.team&.name || 'General'}: #{news.title}"
        puts "    Category: #{news.category} | Impact: #{news.impact_level}"
        puts "    #{news.description}" if news.description
        puts ""
      end
      
      puts "\n🚨 CRITICAL DRIVER NEWS:\n"
      DriverNews.high_impact.affects_performance.recent.each do |news|
        puts "  [#{news.event_date}] #{news.driver&.display_name || 'General'}: #{news.title}"
        puts "    Category: #{news.category} | Impact: #{news.impact_level}"
        puts "    #{news.description}" if news.description
        puts ""
      end
    end

    desc "Examples of news to track"
    task examples: :environment do
      puts "\n📰 EXAMPLES OF NEWS TO TRACK:\n"
      puts "\nTEAM NEWS Categories:"
      puts "  technical:    'Red Bull brings major upgrade package to Barcelona'"
      puts "  personnel:    'Ferrari announces new Technical Director: Adrian Newey'"
      puts "  strategy:     'Mercedes changes race strategy approach for street circuits'"
      puts "  penalty:      'Haas receives constructor penalty for cost cap breach'"
      puts "  regulation:   'New TD affecting ground effect - impacts low-rake cars'"
      puts "  financial:    'Alpine secures major sponsor deal'"
      
      puts "\nDRIVER NEWS Categories:"
      puts "  injury:           'Hamilton recovering from back pain'"
      puts "  penalty:          'Verstappen gets 5-place grid penalty for gearbox change'"
      puts "  contract:         'Leclerc signs contract extension until 2029'"
      puts "  engineer_change:  'Norris gets new race engineer from McLaren GT program'"
      puts "  personal:         'Sainz dealing with family emergency'"
      puts "  form:             'Piastri on hot streak - 3 podiums in 4 races'"
      
      puts "\nUSAGE EXAMPLES:"
      puts "  rails f1:news:add_team['Red Bull Racing',technical,'Major aero upgrade']"
      puts "  rails f1:news:add_driver[VER,penalty,'Grid penalty for engine change']"
      puts "  rails f1:news:list_critical"
    end
  end

  namespace :weather do
    desc "Add weather data manually for a race session"
    task :add, [:round, :session] => :environment do |t, args|
      season = ENV['SEASON']&.to_i || Date.current.year
      race = Race.find_by(season: season, round: args[:round].to_i)
      
      unless race
        puts "❌ Race not found: Season #{season}, Round #{args[:round]}"
        exit 1
      end
      
      puts "Adding weather for #{race.name} - #{args[:session]}..."
      
      print "Condition (Dry/Wet/Mixed/Damp): "
      condition = STDIN.gets.chomp
      
      print "Air temperature (°C): "
      air_temp = STDIN.gets.chomp.to_f
      
      print "Track temperature (°C): "
      track_temp = STDIN.gets.chomp.to_f
      
      print "Humidity (%): "
      humidity = STDIN.gets.chomp.to_i
      
      print "Wind speed (km/h): "
      wind_speed = STDIN.gets.chomp.to_f
      
      print "Wind direction (N/S/E/W/NE/NW/SE/SW): "
      wind_direction = STDIN.gets.chomp
      
      print "Rainfall (mm, 0 if dry): "
      rainfall = STDIN.gets.chomp.to_i
      
      weather = WeatherFetcher.create_manual(
        race,
        args[:session],
        condition: condition,
        air_temp: air_temp,
        track_temp: track_temp,
        humidity: humidity,
        wind_speed: wind_speed,
        wind_direction: wind_direction,
        rainfall: rainfall
      )
      
      puts "✅ Weather data saved for #{race.name} - #{args[:session]}"
      puts "   #{weather.summary}"
    end

    desc "Show weather for a race"
    task :show, [:round] => :environment do |t, args|
      season = ENV['SEASON']&.to_i || Date.current.year
      race = Race.find_by(season: season, round: args[:round].to_i)
      
      unless race
        puts "❌ Race not found: Season #{season}, Round #{args[:round]}"
        exit 1
      end
      
      puts "\n🌤️  WEATHER - #{race.name}\n"
      race.weather_conditions.order(:session_type).each do |weather|
        puts "#{weather.session_type.ljust(12)} | #{weather.summary}"
      end
    end
  end
end
