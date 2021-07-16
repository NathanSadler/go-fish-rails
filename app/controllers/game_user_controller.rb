class GameUserController < ApplicationController
  def create
    @game_user = GameUser.create(game_user_params)

    # Also create a player object
    loaded_go_fish = GoFish.load(game_user_params[:game_id])
    loaded_go_fish.add_player(Player.new(current_user.name,
      @game_user.user_id.to_i))
    loaded_go_fish.save


    redirect_to Game.find(game_id_params[:game_id].to_i)
  end

  private
    def game_user_params
      params.require(:game_user).permit(:user_id, :game_id)
    end

    def game_id_params
      params.require(:game_user).permit(:game_id)
    end
end
