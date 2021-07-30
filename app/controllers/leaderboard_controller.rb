class LeaderboardController < ApplicationController
  def index
    @users = UserStat.all
  end

  def games_won
    @users = UserStat.all
  end

  # def get_users
  #   User.select(:name, "count(case when game_users.is_game_winner then 1 end) as won_games",
  # "count(game_users) as played_games").joins(:games).group(
  #   :name).order(won_games: :desc)
  # end
end
