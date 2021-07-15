module GamesHelper
  def render_show_page(game)
    if (GameUser.where(game_id: game.id, user_id: current_user.id).length == 0)
      render 'show'
    elsif (GameUser.where(game_id: game.id).length < game.minimum_player_count)
      render 'waiting_room'
    else
      render 'main_game_view'
    end
  end
end
