require 'open-uri'

class NfldataController < ApplicationController
  def index
    # @root_url = "http://www.nfl.com/"
    # @liveupdate_url = root_url + "liveupdate/"
    # @scorestrip_url = @liveupdate_url + "scorestrip"
    #
    # current_week_schedule
    # full_schedule(2017)

    # current_week_schedule
    if Nflgame.all.count == 0
      #current_week_schedule
      full_schedule(2017)
    end
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
      Nflgame.create(eid: g['eid'], gsis: g['gsis'], d: g['d'], t: g['t'], q: g['q'], h: g['h'], hnn: g['hnn'], hs: g['hs'], v: g['v'], vnn: g['vnn'], vs: g['vs'], rz: g['rz'], gt: g['gt'], nflweek_id: current_week.id)
    end
  end


  def full_schedule(year)
    season = year
    seasonTypePre = "PRE"
    seasonTypeReg = "REG"
    seasonTypePost = "POST"

    @week = []
    4.times do |w|
      url = "http://www.nfl.com/ajax/scorestrip?season=2017&seasonType=PRE&week=#{w+1}"
      @week[w] = open(url)
    end

    17.times do |w|
      url = "http://www.nfl.com/ajax/scorestrip?season=2017&seasonType=REG&week=#{w+1}"
      @week[w + 4] = open(url)
    end

    5.times do |w|
      if w == 3
        url = "http://www.nfl.com/ajax/scorestrip?season=2017&seasonType=PRO&week=#{w+18}"
        @week[w + 21] = open(url)
      else
        url = "http://www.nfl.com/ajax/scorestrip?season=2017&seasonType=POST&week=#{w+18}"
        @week[w + 21] = open(url)
      end
    end

    @data = []

    @week.each.with_index do |w, i|
      @data[i] = Hash.from_xml(w)
    end
    @data.each.with_index do |d, i|
      @gms = d['ss']['gms']
      gms = @gms
      nflweek = Nflweek.create(w: gms['w'], y: gms['y'], t: gms['t'], gd: gms['gd'], bph: gms['bph'])

      @games = gms['g']

      if @games[1]
        @games.each.with_index do |game, i|
          g = game

          Nflgame.create(
            eid: g['eid'],
            gsis: g['gsis'],
            d: g['d'],
            t: g['t'],
            q: g['q'],
            h: g['h'],
            hnn: g['hnn'],
            hs: g['hs'],
            v: g['v'],
            vnn: g['vnn'],
            vs: g['vs'],
            rz: g['rz'],
            gt: g['gt'],
            nflweek_id: nflweek.id)
        end
      else
        g = @games
        Nflgame.create(
          eid: g['eid'],
          gsis: g['gsis'],
          d: g['d'],
          t: g['t'],
          q: g['q'],
          h: g['h'],
          hnn: g['hnn'],
          hs: g['hs'],
          v: g['v'],
          vnn: g['vnn'],
          vs: g['vs'],
          rz: g['rz'],
          gt: g['gt'],
          nflweek_id: nflweek.id)
      end
    end
  end
end
