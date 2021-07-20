require 'date'
class GamesController < ApplicationController
  def index
  end

  def choose_show_page(game)
    # Replace with a scope when you understand them better
    if (GameUser.where(game_id: game.id, user_id: current_user.id).length == 0)
      render 'show'
    else
      choose_game_show(game)
    end
  end

  def choose_game_show(game)
    if (GameUser.where(game_id: game.id).length < game.minimum_player_count)
      render 'waiting_room'
    elsif
      render 'waiting_to_take_turn'
    else
      render 'taking_turn'
    end
  end

  def show
    @game = Game.find(params[:id])
    @game_user = GameUser.new
    if (GameUser.where(game_id: @game.id).length == @game.minimum_player_count)
      @game.update(started_at: DateTime.now)
    end
    choose_show_page(@game)
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

  def start_game
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
