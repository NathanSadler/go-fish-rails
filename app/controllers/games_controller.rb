require 'date'
class GamesController < ApplicationController
  def index
  end

  def show
    @game = Game.find(params[:id])
    @game_user = GameUser.new
    if (GameUser.where(game_id: @game.id).length == @game.minimum_player_count)
      @game.update(started_at: DateTime.now)
    end
    render_show_page(@game)
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.save
    redirect_to @game
  end

  def update
    @game = Game.find(params[:id])
    try_to_start(@game)
    redirect_to @game
  end

  private
    def game_params
      params.require(:game).permit(:title,
        :minimum_player_count)
    end

    def go_fish_params
      params.require(:go_fish).permit(:id)
    end
end
