# frozen_string_literal: true

class FetchRaceResultsJob < ApplicationJob
  queue_as :default

  def perform(race_id)
    race = Race.find(race_id)

    if race.status_cancelled?
      Rails.logger.info("Race #{race.name} (Round #{race.round}) is cancelled — skipping fetch.")
      return
    end

    client = F1::OpenF1Client.new
    session_key = client.session_key_for_round(year: race.season, round: race.round)

    if session_key.nil?
      Rails.logger.info("No session key for #{race.name} (Round #{race.round}) — skipping fetch.")
      return
    end

    results_data = client.race_results(session_key: session_key)

    results_data.each { |data| upsert_result(race, data) }

    race.update!(status: :completed)
    race.drivers.each { |driver| CalculateMetricsJob.perform_later(driver.id, race.id) }

    Rails.logger.info("Fetched results for #{race.name} - #{results_data.size} drivers")
  end

  private

  def upsert_result(race, data)
    driver = find_or_create_driver(race, data)
    result = Result.find_or_initialize_by(race: race, driver: driver)
    assign_result(result, data)
    result.save!
  end

  def find_or_create_driver(race, data)
    Driver.find_or_create_by!(code: data[:driver_code], season: race.season) do |d|
      d.first_name = data[:driver_first_name]
      d.last_name = data[:driver_last_name]
      d.number = data[:driver_number]
      d.nationality = data[:driver_nationality]
      d.team = find_or_create_team(data[:team_name], race.season)
    end
  end

  def assign_result(result, data)
    result.grid_position = data[:grid_position]
    result.final_position = data[:final_position]
    result.points = data[:points]
    result.status = data[:status]
    result.laps_completed = data[:laps_completed]
    result.fastest_lap_time = data[:fastest_lap_time]
    result.fastest_lap_rank = data[:fastest_lap_rank]
    result.fastest_lap = data[:fastest_lap_rank] == 1
  end

  def find_or_create_team(name, season)
    Team.find_or_create_by!(name: name, season: season) { |t| t.constructor = name }
  end
end
