class LeaderboardController < ApplicationController
  def index
    @users = get_users
  end

  def get_users
    User.select(:name, "count(game_users) as won_games").joins(:games).where(
      game_users: {is_game_winner: true}).group(:name)
  end
end
