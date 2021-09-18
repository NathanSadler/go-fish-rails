require 'date'
class GamesController < ApplicationController

  def index
  end

  def update_card_and_result_partials(game)
    @game.users.each do |user|
      result_partial = ApplicationController.render(partial: "../views/games/round_results", 
        locals: {round_results: game.round_results, current_user: User.find(user.id)})
      ActionCable.server.broadcast("round_#{game.id}_#{user.id}", result_partial)
      card_partial = ApplicationController.render(partial: "../views/games/cards_in_hand", locals: {cards: game.find_player_with_user_id(user.id).hand})
      ActionCable.server.broadcast("card_#{game.id}_#{user.id}", card_partial)
    end  
  end

  def display_waiting_room(game)
    player_list_partial = ApplicationController.render(partial: "../views/games/players_in_lobby",
      locals: {users: game.users})
    ActionCable.server.broadcast("lobby_#{game.id}", player_list_partial)
    render 'waiting_room'
  end

  def choose_show_page(game)
    if (game.finished?)
      render 'game_results'
    elsif (current_user.nil? || !game.has_user?(current_user))
      render 'show'
    else
      choose_game_show(game)
    end
  end

  def choose_game_show(game)
    if (!game.started?)
      display_waiting_room(game)
    elsif (!game.users_turn?(current_user))
      render 'waiting_to_take_turn'
    else
      render 'taking_turn'
    end
  end

  def show
    @game = Game.find(params[:id])
    
    # update_card_and_result_partials(@game)
    @game_user = GameUser.new
    @player_id = session[:user_id]

    respond_to do |format|
      format.html {choose_show_page(@game)}
      format.json {render json: @game.state_for(current_user)}
    end
  end

  def new
    @game = Game.new
  end

  def create
    if logged_in?
      @game = Game.new(game_params)
      @game.save
      redirect_to @game
    else
      redirect_to new
    end
  end

  def update
    @game = Game.find(params[:id])
    requested_player = @game.find_player_with_user_id(params[:game][:requested_player].to_i)
    requested_rank = Card.from_str(params[:game][:requested_rank]).rank
    @game.take_turn(@game.find_player_with_user_id(current_user.id), requested_player: requested_player, requested_rank: requested_rank)
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
