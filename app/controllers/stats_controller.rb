class StatsController < ApplicationController
  def index
    @stats = Stat.all
  end

  def search
    username = find_user(params[:username])

    unless username
      flash[:alert] = 'No Username Match'
      return render action: :index
    end

    @user = username
    find_stats(@user['profileUsers'])
  end

  def find_stats(userData)
    @userId = userData[0].first[1]
    user_game_data = request_api("https://xbl.io/api/v2/achievements/player/#{URI.encode(@userId)}")
    @all_games = user_game_data['titles']
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
    request_api(
      "https://xbl.io/api/v2/friends/search?gt=#{URI.encode(username)}"
    )
  end



end
