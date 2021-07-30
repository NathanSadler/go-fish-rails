
class LeaderboardController < ApplicationController
  def games_won
    @users = UserStat.all.order(won_games: :desc)
  end

  def games_played
    @users = UserStat.all.order(played_games: :desc)
  end

  def game_time
    @users = UserStat.all.order(game_time: :desc)
  end
end
