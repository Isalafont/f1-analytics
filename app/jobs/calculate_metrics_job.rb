# app/jobs/calculate_metrics_job.rb
class CalculateMetricsJob < ApplicationJob
  queue_as :default

  def perform(driver_id, race_id = nil)
    driver = Driver.find(driver_id)
    race = race_id ? Race.find(race_id) : nil

    # Calculate metrics for this specific race
    Metric.calculate_for_driver(driver, race)

    # Also update season aggregate if this is a race-specific calculation
    if race
      Metric.calculate_for_driver(driver, nil)
    end

    Rails.logger.info "Calculated metrics for #{driver.display_name}#{race ? " - #{race.name}" : " (season aggregate)"}"
  end
end
