# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    @season = params[:season]&.to_i || Date.current.year
    load_standings
    load_races
    load_metric_leaderboards
    load_news
  end

  def driver
    @driver = Driver.find(params[:id])
    @season = @driver.season
    @results = @driver.results.joins(:race).order("races.round ASC")
    @metrics = @driver.metrics.race_metrics.joins(:race).order("races.round ASC")
    @season_metric = @driver.metrics.season_aggregates.first
    @teammate = @driver.teammate
    load_driver_chart_data
  end

  def team
    @team = Team.find(params[:id])
    @season = @team.season
    @drivers = @team.drivers.active
    @results = @team.results.joins(:race).order("races.round ASC")
  end

  def race
    @race = Race.find(params[:id])
    @results = @race.results.includes(:driver).order(:final_position)
    @podium = @race.podium
    @weather_conditions = @race.weather_conditions.order(:session_type)
    @was_wet_race = @race.was_wet_race?
    @was_wet_qualifying = @race.was_wet_qualifying?
  end

  private

  def load_standings
    @drivers = season_drivers
    @teams = season_teams
    # Issue #45 — Chart A: standings data for JS Stimulus controller
    @drivers_chart_data = @drivers.map do |d|
      {
        id: d.id,
        last_name: d.last_name,
        team_key: d.team.tailwind_key,
        team_name: d.team.name,
        total_points: d.total_points
      }
    end
  end

  def load_races
    @recent_races = Race.for_season(@season).completed.limit(5)
    @upcoming_races = Race.for_season(@season).upcoming.limit(3)
  end

  def load_metric_leaderboards
    @top_performers = season_metric_drivers("performance_index")
    @most_consistent = season_metric_drivers("consistency_score")
    @hot_form = season_metric_drivers("recent_form").where("metrics.recent_form > 0")
  end

  def load_news
    @critical_team_news = TeamNews.high_impact.affects_performance.recent.includes(:team).limit(5)
    @critical_driver_news = DriverNews.high_impact.affects_performance.recent.includes(:driver).limit(5)
    @recent_team_news = TeamNews.recent.includes(:team).limit(10)
    @recent_driver_news = DriverNews.recent.includes(:driver).limit(10)
  end

  def season_drivers
    # .load forces eager loading — prevents .size from issuing a GROUP BY COUNT
    # that returns a Hash instead of Integer (by_points scope uses group(:id))
    Driver.for_season(@season).includes(:team, :results).by_points.limit(20).load
  end

  def season_teams
    Driver.for_season(@season)
    Team.for_season(@season)
        .includes(:drivers, :results)
        .order(Arel.sql("(SELECT SUM(points) FROM results " \
                        "INNER JOIN drivers ON results.driver_id = drivers.id " \
                        "WHERE drivers.team_id = teams.id) DESC"))
  end

  # Issue #45 — Chart B data for driver page
  def load_driver_chart_data
    @cumulative_points = build_cumulative_points(@results)
    @teammate_cumulative_points = if @teammate
                                    build_cumulative_points(
                                      @teammate.results.joins(:race).order("races.round ASC")
                                    )
                                  else
                                    []
                                  end
  end

  # Issue #45 — Builds cumulative points array for Chart B (Points Evolution)
  # Returns [{race_name: "Australian GP", points: 25, cumulative: 25}, ...]
  def build_cumulative_points(results)
    cumulative = 0
    results.select { |r| r.race.status == "completed" }.map do |result|
      cumulative += result.points.to_i
      { race_name: result.race.name, points: result.points.to_i, cumulative: cumulative }
    end
  end

  def season_metric_drivers(metric_column)
    Driver.for_season(@season)
          .joins(:metrics)
          .where(metrics: { race_id: nil })
          .order(Arel.sql("metrics.#{metric_column} DESC"))
          .limit(10)
  end
end
