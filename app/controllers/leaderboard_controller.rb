class LeaderboardController < ApplicationController
  def index
    @users = User.all.sort_by(&:win_count).reverse
  end
end
