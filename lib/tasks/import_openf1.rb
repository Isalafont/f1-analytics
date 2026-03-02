require "net/http"
require "json"

uri = URI("https://api.openf1.org/v1/sessions?year=2025&session_name=Race")
response = Net::HTTP.get(uri)
sessions = JSON.parse(response)

round = 0
sessions.each do |s|
  round += 1
  Race.find_or_create_by!(season: 2025, round: round) do |r|
    r.name = "#{s['country_name']} Grand Prix"
    r.circuit = s["circuit_short_name"]
    r.country = s["country_name"]
    r.date = DateTime.parse(s["date_start"])
    r.status = "scheduled"
  end
  puts "✓ Round #{round}: #{s['country_name']} - #{s['circuit_short_name']}"
end
puts "✅ #{round} races imported!"
