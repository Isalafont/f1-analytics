# app/jobs/fetch_race_results_job.rb
class FetchRaceResultsJob < ApplicationJob
  queue_as :default

  def perform(race_id)
    race = Race.find(race_id)
    client = F1ApiClient.new(race.season)
    
    results_data = client.fetch_race_results(race.round)
    
    results_data.each do |result_data|
      # Find or create driver
      driver = Driver.find_or_create_by!(
        code: result_data[:driver_code],
        season: race.season
      ) do |d|
        d.first_name = result_data[:driver_first_name]
        d.last_name = result_data[:driver_last_name]
        d.number = result_data[:driver_number]
        d.nationality = result_data[:driver_nationality]
        d.team = find_or_create_team(result_data[:team_name], race.season)
      end

      # Create or update result
      Result.find_or_create_by!(race: race, driver: driver) do |r|
        r.grid_position = result_data[:grid_position]
        r.final_position = result_data[:final_position]
        r.points = result_data[:points]
        r.status = result_data[:status]
        r.laps_completed = result_data[:laps_completed]
        r.fastest_lap_time = result_data[:fastest_lap_time]
        r.fastest_lap_rank = result_data[:fastest_lap_rank]
        r.fastest_lap = result_data[:fastest_lap_rank] == 1
      end
    end

    # Mark race as completed
    race.update(status: 'completed')

    # Trigger metrics calculation for all drivers
    race.drivers.each do |driver|
      CalculateMetricsJob.perform_later(driver.id, race.id)
    end

    Rails.logger.info "Fetched results for #{race.name} - #{results_data.size} drivers"
  end

  private

  def find_or_create_team(name, season)
    Team.find_or_create_by!(name: name, season: season) do |t|
      t.constructor = name  # Can be refined later
    end
  end
end
