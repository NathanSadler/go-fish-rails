class Game < ApplicationRecord
  has_many :game_users
  has_many :users, through: :game_users
  serialize :go_fish, GoFish

  def add_player(player)
    go_fish.add_player(player)
    !save
  end

  def current_player_index
    go_fish.current_player_index
  end

  def deck
    go_fish.deck
  end

  def list_cards_of_player_with_user_id(user_id)
    go_fish.list_cards_of_player_with_user_id(user_id)
  end

  def players
    go_fish.players
  end

  def set_deck(deck)
    go_fish.deck.send(:set_cards, deck)
    !save
  end

  def set_player_hand(player_index, new_hand)
    go_fish.players[player_index].send(:set_hand, new_hand)
    !save
  end

  def take_turn(player, requested_player:, requested_rank: "H")
    go_fish.take_turn
    !save
  end

  def turn_player
    go_fish.turn_player
  end

end
