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

    races_to_fetch = Race.for_season(season)
                         .where(status: :scheduled)
                         .where("date < ?", Date.current)
                         .order(:round)

    if races_to_fetch.empty?
      Rails.logger.info "[FetchScheduledRacesJob] No races to fetch for season #{season}."
      return
    end

    Rails.logger.info "[FetchScheduledRacesJob] #{races_to_fetch.size} race(s) to fetch: " \
                      "#{races_to_fetch.map(&:name).join(', ')}"

    races_to_fetch.each do |race|
      FetchRaceResultsJob.perform_later(race.id)
      Rails.logger.info "[FetchScheduledRacesJob] Enqueued FetchRaceResultsJob for #{race.name} (Round #{race.round})"
    end
  end
end
