class GoFish
  attr_reader :players, :deck, :current_player_index, :game_id, :round_results

  def initialize(players = [], deck = Deck.new, current_player_index = 0, game_id: 0)
    @players = players
    @deck = deck
    @current_player_index = current_player_index
    @game_id = game_id
    @round_results = []
  end

  def add_player(player)
    set_players(players.push(player))
  end

  def as_json
    { 'players' => players.map(&:as_json),
      'deck' => deck.as_json,
      'current_player_index' => current_player_index,
      'game_id' => game_id, 'round_results' => round_results.map(&:as_json)
    }
  end

  def deal_cards
    players.length > 3 ? (card_deal_count = 5) : (card_deal_count = 7)
    card_deal_count.times do
      players.each {|player| player.add_card_to_hand(deck.draw_card)}
    end
  end

  def self.dump(obj)
    obj.as_json
  end

  def find_player_with_user_id(user_id)
    players.each {|player| return player if player.user_id == user_id}
    return nil
  end

  def finish_turn(round_result, player)
    save_round_result(round_result)
    next_player if (!round_result.matched_rank?)
    player.lay_down_books
  end

  def self.from_json(json)
    restored_players = json['players'].map {|json_player| Player.from_json(json_player)}
    restored_deck = Deck.from_json(json['deck'])
    restored_go_fish = GoFish.new(restored_players, restored_deck, json['current_player_index'],
      game_id: json['game_id'])
    restored_go_fish.send(:set_round_results, json["round_results"].map {|round_result| RoundResult.from_json(round_result)})
    restored_go_fish
  end

  def increment_current_player_index
    set_current_player_index(current_player_index + 1)
  end

  def list_cards_of_player_with_user_id(user_id)
    player = find_player_with_user_id(user_id)
    player.hand
  end

  def self.load(json)
    return GoFish.new if json.blank?
    self.from_json(json)
  end

  def next_player
    increment_current_player_index
    until (!turn_player.hand.empty?)
      deck.empty? ? increment_current_player_index : turn_player.add_card_to_hand(deck.draw_card)  
    end
  end

  def over?
    cards_in_hands = players.map(&:hand).map(&:length).sum
    (cards_in_hands == 0) && (deck.empty?)
  end

  def save
    associated_game = Game.find(game_id)
    associated_game.go_fish = as_json
    associated_game.save
  end

  def save_round_result(result_to_save)
    new_round_results = [result_to_save] + round_results
    set_round_results(new_round_results)
  end

  def take_turn(player, requested_player:, requested_rank: "H")
    if(requested_player.has_card_with_rank?(requested_rank))
       won_cards, card_source = [player.add_card_to_hand(requested_player.remove_cards_with_rank(requested_rank)), requested_player]
    else
      won_cards, card_source = [player.draw_card(deck), "the deck"]
    end
    round_result = RoundResult.new(cards: won_cards, recieving_player: player, expected_rank: requested_rank, source: card_source, asked_player: requested_player)
    finish_turn(round_result, player)
  end

  def turn_player
    players[current_player_index]
  end

  private
    def set_current_player_index(new_value)
      @current_player_index = new_value % players.length
    end

    def set_game_id(new_id)
      @game_id = new_id
    end

    def set_players(new_players)
      @players = new_players
    end

    def set_round_results(new_round_results)
      @round_results = new_round_results
    end
end

# Method(s) I might need to add later:
# shuffle_and_deal
