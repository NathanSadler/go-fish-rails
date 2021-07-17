class GoFishController < ApplicationController
  def show
    @go_fish = GoFish.load(params[:id])
    if current_user.id == turn_player_id(params[:id])
      redirect_to edit_go_fish_path(params[:id])
    # else
    #   render 'main_game_view'
    end
  end

  def edit
    @go_fish = GoFish.load(params[:id])
  end

  def patch
    @go_fish = GoFish.load(params[:id])
    @go_fish.take_turn
    @go_fish.save
  end
end
