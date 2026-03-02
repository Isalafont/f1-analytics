# app/controllers/dashboard_controller.rb
class DashboardController < ApplicationController
  def index
    @season = params[:season]&.to_i || Date.current.year
    
    # Current standings
    @drivers = Driver.for_season(@season)
                     .includes(:team, :results)
                     .by_points
                     .limit(20)
    
    @teams = Team.for_season(@season)
                 .includes(:drivers, :results)
                 .order('(SELECT SUM(points) FROM results INNER JOIN drivers ON results.driver_id = drivers.id WHERE drivers.team_id = teams.id) DESC')

    # Recent races
    @recent_races = Race.for_season(@season)
                        .completed
                        .limit(5)
    
    # Upcoming races
    @upcoming_races = Race.for_season(@season)
                          .upcoming
                          .limit(3)

    # Top performers (by performance index)
    @top_performers = Driver.for_season(@season)
                            .joins(:metrics)
                            .where(metrics: { race_id: nil })
                            .order('metrics.performance_index DESC')
                            .limit(10)

    # Most consistent (by consistency score)
    @most_consistent = Driver.for_season(@season)
                             .joins(:metrics)
                             .where(metrics: { race_id: nil })
                             .order('metrics.consistency_score DESC')
                             .limit(10)

    # Hot form (recent 3 races)
    @hot_form = Driver.for_season(@season)
                      .joins(:metrics)
                      .where(metrics: { race_id: nil })
                      .where('metrics.recent_form > 0')
                      .order('metrics.recent_form DESC')
                      .limit(10)

    # Critical news (high impact affecting performance)
    @critical_team_news = TeamNews.high_impact.affects_performance.recent.includes(:team).limit(5)
    @critical_driver_news = DriverNews.high_impact.affects_performance.recent.includes(:driver).limit(5)
    
    # Recent news (all categories)
    @recent_team_news = TeamNews.recent.includes(:team).limit(10)
    @recent_driver_news = DriverNews.recent.includes(:driver).limit(10)
  end

  def driver
    @driver = Driver.find(params[:id])
    @season = @driver.season
    
    @results = @driver.results.joins(:race).order('races.round ASC')
    @metrics = @driver.metrics.race_metrics.joins(:race).order('races.round ASC')
    @season_metric = @driver.metrics.season_aggregates.first
    @teammate = @driver.teammate
  end

  def team
    @team = Team.find(params[:id])
    @season = @team.season
    
    @drivers = @team.drivers.active
    @results = @team.results.joins(:race).order('races.round ASC')
  end

  def race
    @race = Race.find(params[:id])
    @results = @race.results.includes(:driver).order(:final_position)
    @podium = @race.podium
    @weather_conditions = @race.weather_conditions.order(:session_type)
    
    # Weather analysis
    @was_wet_race = @race.was_wet_race?
    @was_wet_qualifying = @race.was_wet_qualifying?
  end
end
