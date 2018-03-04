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
      current_week_schedule
    end
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
    #
    # schedule_url = @scorestrip_url + "/ss.xml"
    # # game_data_url = @liveupdate_url + "game-center/#{eid}/#{eid}_gtd.json"
    #
    # games_data = open("http://www.nfl.com/liveupdate/scorestrip/ss.xml")
    # games = Hash.from_xml(games_data)
    # @gms = games['ss']['gms']
    # @g = @gms['g']
    #
    # current_week = Nflweek.create(w: @gms['w'], y: @gms['y'], t: @gms['t'], gd: @gms['gd'], bph: @gms['bph'])
    #
    # @g.each do |g|
    #   Nflgame.create(eid: g['eid'], gsis: g['gsis'], d: g['d'], t: g['t'], q: g['q'], h: g['h'], hnn: g['hnn'], hs: g['hs'], v: g['v'], vnn: g['vnn'], vs: g['vs'], rz: g['rz'], gt: g['gt'], nflweek_id: current_week.id)
    # end
  end


  def full_schedule(year)
    season = year
    seasonTypePre = "PRE"
    seasonTypeReg = "REG"
    seasonTypePost = "POST"

    week = []

    25.times do |w|
      if w >= 1 && w < 5
        # Preseason
        url = "http://www.nfl.com/ajax/scorestrip?season=#{season}&seasonType=#{seasonTypePre}&week=#{w}"
      elsif w >= 5 && w < 21
        # Regular season
        wk = w - 4
        url = "http://www.nfl.com/ajax/scorestrip?season=#{season}&seasonType=#{seasonTypeReg}&week=#{wk}"
      elsif w >= 21 && w < 25
        # Post season
        wk = w - 4
        url = "http://www.nfl.com/ajax/scorestrip?season=#{season}&seasonType=#{seasonTypePost}&week=#{wk}"
      else
        # something went wrong
        url = "http://www.reddit.com/r/nfl"
      end

      # open(url)
      week[w] = open(url)
    end

    # 4.times do |w|
    #   url = "http//www.nfl.com/ajax/scorestrip?season=#{season}&seasonType=#{seasonTypePre}&week=#{w}"
    #   week[w] = open(url)
    # end
    #
    # 17.times do |w|
    #   url = root_url + arbitrary_week_games_base_path + attr_season + "2017&" + attr_seasonType + "REG&" + attr_week + w
    #   week[w + 4] = open(url)
    # end
    #
    # 4.times do |w|
    #   url = root_url + arbitrary_week_games_base_path + attr_season + "2017&" + attr_seasonType + "POST&" + attr_week + w
    #   week[w + 21] = open(url)
    # end

    week.each do |w, i|

      data = Hash.from_xml(w)

      @gms = data['ss']['gms']
      gms = @gms
      nflweek = Nflweek.create(w: gms['w'], y: gms['y'], t: gms['t'], gd: gms['gd'], bph: gms['bph'])

      @g = gms['g']
      g = @g
      @g.each do |g|
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
