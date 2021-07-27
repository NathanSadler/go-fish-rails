require 'date'

class Game < ApplicationRecord
  has_many :game_users
  has_many :users, through: :game_users
  serialize :go_fish, GoFish

  scope :finished, -> {where.not(finished_at: nil)}

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

  def finish
    update(finished_at: DateTime.current)
    winners_ids = go_fish.winning_players.map(&:user_id)
    winners_ids.each {|winner_id| GameUser.where(user_id: winner_id, game_id: id).update(is_game_winner: true)}
    losers_ids = go_fish.losing_players.map(&:user_id)
    losers_ids.each {|loser_id| GameUser.where(user_id: loser_id, game_id: id).update(is_game_winner: false)}
  end

  # used in games controller and taking_turn
  def find_player_with_user_id(user_id)
    go_fish.find_player_with_user_id(user_id)
  end

  # used in waiting_to_take_turn, but only once.
  def list_cards_of_player_with_user_id(user_id)
    go_fish.list_cards_of_player_with_user_id(user_id)
  end

  # used in game controller
  def finished?
    finished_at.present?
  end

  # used in taking_turn, but only once
  def players
    go_fish.players
  end

  def ready_to_start?
    GameUser.where(game_id: id).length >= minimum_player_count
  end

  def started?
    started_at.present?
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
    finish if go_fish.over?
  end

  def try_to_start
    if (!started? && ready_to_start?)
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

  def users_turn?(user)
    user.id == go_fish.turn_player.user_id
  end

  def has_user?(user)
    GameUser.where(game_id: id, user_id: user.id).length > 0
  end

  def round_results
    go_fish.round_results
  end

end
