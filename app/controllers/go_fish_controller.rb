class GoFishController < ApplicationController
  def show
    @go_fish = GoFish.load(params[:id])
    if current_user.id == turn_player_id(params[:id])
      redirect_to edit_go_fish_path(params[:id])
    end
  end

  def edit
    @go_fish = GoFish.load(params[:id])
  end

  def update
    @go_fish = GoFish.load(params[:id])
    @go_fish.take_turn
    @go_fish.save
    redirect_to go_fish_path(@go_fish.game_id)
  end
end
