require 'open-uri'

class NfldataController < ApplicationController
  def index
  end

  def show

  end

  def current_week_schedule

    current_week_games_path = "liveupdate/scorestrip/ss.xml"
    arbitrary_week_games_base_path = "ajax/scorestrip?"
    attr_season = "season="
    attr_seasonType = "seasonType="
    attr_week = "week="

    game_data_path = "liveupdate/game-center/"
    url_end = "_gtd.json"

    data = open("http://www.nfl.com/liveupdate/scorestrip/ss.xml")

    current_week_data = Hash.from_xml(data)

    @gms = current_week_data['ss']['gms']
    @g = @gms['g']

    current_week = Nflweek.create(w: @gms['w'], y: @gms['y'], t: @gms['t'], gd: @gms['gd'], bph: @gms['bph'])

    @g.each do |g|
      hteam = Nflteam.find_by(abbr: g['h'])
      vteam = Nflteam.find_by(abbr: g['v'])
      Nflgame.create(
        eid: g['eid'],
        gsis: g['gsis'],
        d: g['d'],
        t: g['t'],
        q: g['q'],
        h: hteam.id,
        hs: g['hs'],
        v: vteam.id,
        vs: g['vs'],
        rz: g['rz'],
        gt: g['gt'],
        nflweek_id: current_week.id)
    end
  end

  def createNflTeams(teams)
    teams.each do |t|
      Nflteam.create(
        abbr: t.abbr,
        nn: t.nn,
        wins: t.wins,
        losses: t.losses)
    end
  end

  def countNflTeams
    return count(Nflteam.all)
  end
end
