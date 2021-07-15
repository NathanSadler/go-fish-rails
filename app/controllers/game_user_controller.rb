class GameUserController < ApplicationController
  def create
    @game_user = GameUser.create(game_user_params)
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
