class LeaderboardController < ApplicationController
  def games_won
    @users = UserStat.all.order(won_games: :desc)
  end

  def games_played
    @users = UserStat.all.order(played_games: :desc)
  end

  def game_time_leaderboard
    @users = UserStat.all.order(game_time: :desc)
  end


  # def get_users
  #   User.select(:name, "count(case when game_users.is_game_winner then 1 end) as won_games",
  # "count(game_users) as played_games").joins(:games).group(
  #   :name).order(won_games: :desc)
  # end
end
