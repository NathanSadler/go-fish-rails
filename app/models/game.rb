class Game < ApplicationRecord
  has_many :game_users
  has_many :users, through: :game_users
  serialize :go_fish, GoFish

  def take_turn(player, requested_player:, requested_rank: "H")
    go_fish.take_turn
    !save
  end

  def add_player(player)
    go_fish.add_player(player)
    !save
  end

  def players
    go_fish.players
  end
end
