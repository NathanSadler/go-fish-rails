require 'date'

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

  # used in waiting_to_take_turn, but only once.
  def list_cards_of_player_with_user_id(user_id)
    go_fish.list_cards_of_player_with_user_id(user_id)
  end

  # used in taking_turn, but only once
  def players
    go_fish.players
  end

  # used once in games_helper, but you could probably merge game#deal and
  # game#shuffle, letting you get rid of the two individual game methods
  def shuffle
    go_fish.deck.shuffle
    save!
  end

  def take_turn(player, requested_player:, requested_rank: "H")
    go_fish.take_turn(player, requested_player: requested_player,
      requested_rank: requested_rank)
    save!
  end

  def try_to_start
    if (GameUser.where(game_id: id).length >= minimum_player_count)
      go_fish.deck.shuffle
      go_fish.deal_cards
      update(started_at: DateTime.current)
      save!
    end
  end

  # used in games_controller and games_helper
  def turn_player
    go_fish.turn_player
  end

  def round_results
    go_fish.round_results
  end

end
