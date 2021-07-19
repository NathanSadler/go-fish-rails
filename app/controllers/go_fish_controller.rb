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
    @go_fish = GoFish.load(params[:id])
    requested_player = @go_fish.find_player_with_user_id(params[params[:id]][:requested_player].to_i)
    requested_rank = Card.from_str(params[params[:id]][:requested_rank]).rank
    @go_fish.take_turn(@go_fish.find_player_with_user_id(current_user.id),
      requested_player: requested_player, requested_rank: requested_rank)
    @go_fish.save
    redirect_to go_fish_path(@go_fish.game_id)
  end
end
