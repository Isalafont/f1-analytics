# frozen_string_literal: true

# FetchScheduledRacesJob — déclenche FetchRaceResultsJob pour chaque course
# dont la date est passée mais le status est encore "scheduled".
#
# Prévu pour tourner via Solid Queue recurring (config/recurring.yml).
# Fréquence recommandée : toutes les heures le dimanche des GPs, ou quotidien en semaine.
#
# Ne touche pas aux courses "cancelled" ou "completed" — idempotent.
class FetchScheduledRacesJob < ApplicationJob
  queue_as :default

  def perform
    season = Date.current.year
    races = scheduled_races_to_fetch(season)

    if races.empty?
      log_empty(season)
      return
    end

    log_start(races)
    enqueue_races(races)
  end

  private

  def scheduled_races_to_fetch(season)
    Race.for_season(season)
        .where(status: :scheduled)
        .where(date: ...Date.current)
        .order(:round)
  end

  def log_empty(season)
    Rails.logger.info "[FetchScheduledRacesJob] No races to fetch for season #{season}."
  end

  def log_start(races)
    Rails.logger.info "[FetchScheduledRacesJob] #{races.size} race(s) to fetch: " \
                      "#{races.map(&:name).join(", ")}"
  end

  def enqueue_races(races)
    races.each do |race|
      FetchRaceResultsJob.perform_later(race.id)
      Rails.logger.info "[FetchScheduledRacesJob] Enqueued FetchRaceResultsJob for #{race.name} (Round #{race.round})"
    end
  end
end
