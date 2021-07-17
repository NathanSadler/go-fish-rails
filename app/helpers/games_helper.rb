module GamesHelper
  def render_show_page(game)
    if (GameUser.where(game_id: game.id, user_id: current_user.id).length == 0)
      render 'show'
    elsif (GameUser.where(game_id: game.id).length < game.minimum_player_count)
      render 'waiting_room'
    else
      redirect_to go_fish_path(game)
    end
  end

  def turn_player_id(game_id)
    loaded_go_fish = GoFish.load(game_id)
    loaded_go_fish.turn_player.user_id
  end
end
