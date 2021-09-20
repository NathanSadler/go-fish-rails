class GameUserController < ApplicationController
  def create
    @game_user = GameUser.create(game_user_params)

    # Also create a player object
    game = Game.find(game_user_params[:game_id])
    game.add_player(Player.new(current_user.name, @game_user.user_id.to_i)) if logged_in?
    #game.save

    partial = ApplicationController.render(partial: '../views/games/players_in_lobby', locals: {users: game.users})
    ActionCable.server.broadcast("lobby_#{game.id}", partial)
    redirect_to Game.find(game_id_params[:game_id].to_i)
  end

  def show
    # binding.pry
    game_user = GameUser.find(params[:id].to_i)
    render json: game_user.json_for_others
  end

  private
    def game_user_params
      params.require(:game_user).permit(:user_id, :game_id)
    end

    def game_id_params
      params.require(:game_user).permit(:game_id)
    end
end
