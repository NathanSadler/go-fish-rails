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
    if (!game.ready_to_start?)
      render 'waiting_room'
    elsif (game.turn_player.user_id != current_user.id)
      render 'waiting_to_take_turn'
    else
      render 'taking_turn'
    end
  end

  def show
    @game = Game.find(params[:id])
    @game_user = GameUser.new
    @player_id = current_user.id
    # NOTE: get rid of this part
    if (GameUser.where(game_id: @game.id).length == @game.minimum_player_count)
      @game.update(started_at: DateTime.current)
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
    #binding.pry
    @game = Game.find(params[:id])
    requested_player = @game.find_player_with_user_id(params[:game][:requested_player].to_i)
    requested_rank = Card.from_str(params[:game][:requested_rank]).rank
    @game.take_turn(@game.find_player_with_user_id(current_user.id),
      requested_player: requested_player, requested_rank: requested_rank)
    redirect_to game_path(@game.id)
  end

  def start_game
    @game = Game.find(params[:game])
    @game.try_to_start
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
