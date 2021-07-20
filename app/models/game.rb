class Game < ApplicationRecord
  has_many :game_users
  has_many :users, through: :game_users
  serialize :go_fish, GoFish

  def add_player(player)
    go_fish.add_player(player)
    save!
  end

  # NOTE: gets to stay for now, but you could probably just create some sort of
  # start_game method instead
  def deal_cards
    go_fish.deal_cards
    save!
  end

  # used in games controller and taking_turn
  def find_player_with_user_id(user_id)
    go_fish.find_player_with_user_id(user_id)
  end

  def list_cards_of_player_with_user_id(user_id)
    go_fish.list_cards_of_player_with_user_id(user_id)
  end

  def players
    go_fish.players
  end

  def round_results
    go_fish.round_results
  end

  def set_deck(deck)
    go_fish.deck.send(:set_cards, deck)
    save!
  end

  def set_player_hand(player_index, new_hand)
    go_fish.players[player_index].send(:set_hand, new_hand)
    save!
  end

  def shuffle
    go_fish.deck.shuffle
    save!
  end

  def take_turn(player, requested_player:, requested_rank: "H")
    go_fish.take_turn(player, requested_player: requested_player,
      requested_rank: requested_rank)
    save!
  end

  def turn_player
    go_fish.turn_player
  end

end
