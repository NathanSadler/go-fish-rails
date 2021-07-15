class GamesController < ApplicationController
  def index
  end

  def show
    @game = Game.find(params[:id])
    @game_user = GameUser.new
    # binding.pry
    if (GameUser.where(game_id: @game.id).length < @game.minimum_player_count)
      # render 'waiting_room'
    end

  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.save
    redirect_to @game
  end

  private
    def game_params
      params.require(:game).permit(:title,
        :minimum_player_count)
    end
end
