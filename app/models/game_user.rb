class GameUser < ApplicationRecord
  belongs_to :game
  belongs_to :user

  def json_for_others
    game.find_player_with_user_id(user.id).json_for_others
  end
end
