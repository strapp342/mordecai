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
      #full_schedule(2017)
    end

    @gamesJson = []

    @allgames = Nflgame.all
    @allgames.each_with_index do |game, i|
      url = "http://www.nfl.com/liveupdate/game-center/#{game.eid}/#{game.eid}_gtd.json"
      @gamesJson[i] = JSON.parse(open(url).read)
    end
    @game = @gamesJson[0]['2017123102']
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

    # 25.times do |w|
    #   if w >= 1 && w < 5
    #     # Preseason
    #     @url = "http://www.nfl.com/ajax/scorestrip?season=#{season}&seasonType=#{seasonTypePre}&week=#{w}"
    #   elsif w >= 5 && w < 21
    #     # Regular season
    #     wk = w - 4
    #     @url = "http://www.nfl.com/ajax/scorestrip?season=#{season}&seasonType=#{seasonTypeReg}&week=#{wk}"
    #   elsif w >= 21 && w < 25
    #     # Post season
    #     wk = w - 4
    #     @url = "http://www.nfl.com/ajax/scorestrip?season=#{season}&seasonType=#{seasonTypePost}&week=#{wk}"
    #   else
    #     # something went wrong
    #     @url = "http://www.nfl.com/ajax/scorestrip?season=2017&seasonType=REG&week=4"
    #     break
    #   end

    #   # open(url)
    #   week[w] = open(@url)
    # end

     4.times do |w|
       url = "http://www.nfl.com/ajax/scorestrip?season=2017&seasonType=PRE&week=#{w+1}"
       @week[w] = open(url)
     end

     17.times do |w|
       url = "http://www.nfl.com/ajax/scorestrip?season=2017&seasonType=REG&week=#{w}"
       @week[w + 4] = open(url)
     end

     4.times do |w|
       url = "http://www.nfl.com/ajax/scorestrip?season=2017&seasonType=POST&week#{w}"
       @week[w + 21] = open(url)
     end

    @data = []

    @week.each.with_index do |w, i|
      @data[i] = Hash.from_xml(w)
    end
    @data.each.with_index do |d, i|
      @gms = d['ss']
     # @gms = d['ss']['gms']
     # gms = @gms
     # nflweek = Nflweek.create(w: gms['w'], y: gms['y'], t: gms['t'], gd: gms['gd'], bph: gms['bph'])

     # @games = gms['g']

      #@games.each.with_index do |game, i|
      #  @g = game
      #
      #  Nflgame.create(
      #    eid: g[i]['eid'],
      #    gsis: g['gsis'],
      #    d: g['d'],
      #    t: g['t'],
      #    q: g['q'],
      #    h: g['h'],
      #    hnn: g['hnn'],
      #    hs: g['hs'],
      #    v: g['v'],
      #    vnn: g['vnn'],
      #    vs: g['vs'],
      #    rz: g['rz'],
      #    gt: g['gt'],
      #    nflweek_id: nflweek.id)
      #end
    end
  end
end
