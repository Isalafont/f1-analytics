# frozen_string_literal: true

require "rails_helper"

RSpec.describe FetchRaceResultsJob, type: :job do
  let(:season) { 2026 }
  let(:team) { create(:team, name: "Mercedes", season: season) }
  let(:race) { create(:race, season: season, round: 1, status: :scheduled) }
  let(:client) { instance_double(F1::OpenF1Client) }

  let(:mock_results) do
    [
      { driver_number: 63, driver_code: "RUS", driver_first_name: "George",
        driver_last_name: "Russell", driver_nationality: "GBR", team_name: "Mercedes",
        final_position: 1, points: 25, status: "Finished",
        grid_position: nil, laps_completed: nil,
        fastest_lap_time: nil, fastest_lap_rank: nil, session_key: 11_234 },
      { driver_number: 12, driver_code: "ANT", driver_first_name: "Kimi",
        driver_last_name: "Antonelli", driver_nationality: "ITA", team_name: "Mercedes",
        final_position: 2, points: 18, status: "Finished",
        grid_position: nil, laps_completed: nil,
        fastest_lap_time: nil, fastest_lap_rank: nil, session_key: 11_234 }
    ]
  end

  before do
    allow(F1::OpenF1Client).to receive(:new).and_return(client)
    allow(client).to receive(:session_key_for_round).with(year: season, round: 1).and_return(11_234)
    allow(client).to receive(:race_results).with(session_key: 11_234).and_return(mock_results)
    allow(CalculateMetricsJob).to receive(:perform_later)
  end

  describe "#perform" do
    context "when race is scheduled" do
      it "fetches results and creates Result records" do
        expect { described_class.perform_now(race.id) }
          .to change(Result, :count).by(2)
      end

      it "creates drivers if they don't exist" do
        expect { described_class.perform_now(race.id) }
          .to change(Driver, :count).by(2)
      end

      it "sets correct points on results" do
        described_class.perform_now(race.id)
        expect(Result.find_by(race: race, final_position: 1).points).to eq(25)
        expect(Result.find_by(race: race, final_position: 2).points).to eq(18)
      end

      it "marks race as completed" do
        described_class.perform_now(race.id)
        expect(race.reload.status).to eq("completed")
      end

      it "enqueues CalculateMetricsJob for each driver" do
        described_class.perform_now(race.id)
        expect(CalculateMetricsJob).to have_received(:perform_later).twice
      end
    end

    context "when race is cancelled" do
      let(:race) { create(:race, season: season, round: 4, status: :cancelled) }

      it "skips the fetch without raising" do
        expect { described_class.perform_now(race.id) }.not_to change(Result, :count)
      end

      it "does not call the API client" do
        described_class.perform_now(race.id)
        expect(client).not_to have_received(:race_results)
      end
    end

    context "when session_key_for_round returns nil (cancelled in constants)" do
      before do
        allow(client).to receive(:session_key_for_round).and_return(nil)
      end

      it "skips the fetch without raising" do
        expect { described_class.perform_now(race.id) }.not_to change(Result, :count)
      end

      it "does not call race_results" do
        described_class.perform_now(race.id)
        expect(client).not_to have_received(:race_results)
      end
    end

    context "when running the job twice (idempotence)" do
      it "does not duplicate Result records" do
        described_class.perform_now(race.id)
        race.update!(status: :scheduled) # reset for second run
        expect { described_class.perform_now(race.id) }.not_to change(Result, :count)
      end
    end

    context "when API returns empty results" do
      before do
        allow(client).to receive(:race_results).and_return([])
      end

      it "does not crash" do
        expect { described_class.perform_now(race.id) }.not_to raise_error
      end

      it "still marks race as completed" do
        described_class.perform_now(race.id)
        expect(race.reload.status).to eq("completed")
      end
    end
  end
end
