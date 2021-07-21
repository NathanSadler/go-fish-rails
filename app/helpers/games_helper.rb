require 'date'
module GamesHelper
  def try_to_start(game)
    if (GameUser.where(game_id: game.id).length >= game.minimum_player_count)
      # game = Game.find(game.id)
      game.shuffle
      game.deal_cards
      game.started_at = DateTime.current
    end
  end
end
