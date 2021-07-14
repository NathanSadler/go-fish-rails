class GamesController < ApplicationController
  def index
  end

  def show
    @game = Game.find(params[:id])
    @game_user = GameUser.new
  end

  def new
    @game = Game.new
  end

  def create
    @user = Game.new(game_params)
    @user.save
  end

  private
    def game_params
      params.require(:game).permit(:title)
    end
end
