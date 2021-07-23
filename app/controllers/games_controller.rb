require 'date'
class GamesController < ApplicationController

  def index
  end

  def choose_show_page(game)
    if (game.over?)
      render 'game_results'
    elsif (!game.has_user?(current_user))
      render 'show'
    else
      choose_game_show(game)
    end
  end

  def choose_game_show(game)
    ActionCable.server.broadcast("lobby_#{game.id}", "But I will never let go")
    if (!game.ready_to_start?)
      render 'waiting_room'
    elsif (!game.users_turn?(current_user))
      render 'waiting_to_take_turn'
    else
      render 'taking_turn'
    end
  end

  def show
    @game = Game.find(params[:id])
    @game_user = GameUser.new
    @player_id = current_user.id
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
    ActionCable.server.broadcast("round_#{@game.id}", "Can't hold on much longer")
    requested_player = @game.find_player_with_user_id(params[:game][:requested_player].to_i)
    requested_rank = Card.from_str(params[:game][:requested_rank]).rank
    @game.take_turn(@game.find_player_with_user_id(current_user.id),
      requested_player: requested_player, requested_rank: requested_rank)
    redirect_to game_path(@game.id)
  end

  def join_game(game)
    @game = Game.find(params[:id])

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
