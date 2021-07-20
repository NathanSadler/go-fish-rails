require 'date'
module GamesHelper
  def render_show_page(game)
    # If there aren't any records in the GameUser table that have this game's
    # id and this user's id, render the basic show page
    if (GameUser.where(game_id: game.id, user_id: current_user.id).length == 0)
      render 'show'
    elsif (GameUser.where(game_id: game.id).length < game.minimum_player_count)
      render 'waiting_room'
    else
      redirect_to go_fish_path(game)
    end
  end

  def turn_player_id(game_id)
    game = Game.find(game_id)
    game.turn_player.user_id
  end

  def try_to_start(game)
    if (GameUser.where(game_id: game.id).length >= game.minimum_player_count)
      # game = Game.find(game.id)
      game.shuffle
      game.deal_cards
      game.started_at = DateTime.now
    end
  end
end
