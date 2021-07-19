class GoFishController < ApplicationController
  def show
    @game = Game.find(params[:id])
    if current_user.id == turn_player_id(params[:id])
      redirect_to edit_go_fish_path(params[:id])
    end
  end

  def edit
    @game = Game.find(params[:id])
    @player_id = current_user.id
  end

  def update
    @game = Game.find(params[:id])
    requested_player = @game.find_player_with_user_id(params[:game][:requested_player].to_i)
    requested_rank = Card.from_str(params[:game][:requested_rank]).rank
    @game.take_turn(@game.find_player_with_user_id(current_user.id),
      requested_player: requested_player, requested_rank: requested_rank)
    redirect_to go_fish_path(@game.id)
  end
end
