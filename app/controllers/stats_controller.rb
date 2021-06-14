class StatsController < ApplicationController

  def index
    @stats = Stat.all
  end

  def search
    find_user(params[:username])

    unless @user
      flash[:alert] = 'No Username Match'
      return render action: :index
    end
    find_stats(@user['profileUsers'])
  end

  def show
    game_id = params[:gameId]
    user_id = params[:userId]
    find_user_game(user_id, game_id)
  end

  def find_stats(userData)
    @userId = userData[0].first[1]
    user_id_in_state(@userId)
    @xbox_gamertag = userData[0]['settings'][2]['value']
    user_game_data = find_user_game_data(@userId)
    @all_games = user_game_data['titles']
    @total_achievements = @all_games.reduce(0) { |sum, obj| sum + obj['achievement']['currentAchievements']}
    @total_gamerscore = @all_games.reduce(0) { |sum, obj| sum + obj['achievement']['currentGamerscore']}
  end

  private

  def request_api(url)
    response = Excon.get(
      url,
      headers: {
        'X-Authorization' => ENV.fetch('XBOX_AUTH_KEY')
      }
    )
    return nil if response.status != 200
    JSON.parse(response.body)
  end

  def find_user(username)
    @user = request_api("https://xbl.io/api/v2/friends/search?gt=#{URI.encode(username)}")
    @userId = @user['profileUsers'][0].first[1]
  end

  def find_user_game_data(userId)
    request_api("https://xbl.io/api/v2/achievements/player/#{URI.encode(userId)}")
  end

  def user_id_in_state(id)
    @stored_user_id = id
  end

  def find_user_game(user_id, game_id)
    @selected_game = request_api("https://xbl.io/api/v2/achievements/player/#{URI.encode(user_id)}/title/#{URI.encode(game_id)}")
  end

end
