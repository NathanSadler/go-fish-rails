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
      'game_id' => game_id
    }
  end

  # NOTE: gets to stay for now, but you could probably just create some sort of
  # start_game method instead 
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

  def self.from_json(json)
    restored_players = json['players'].map {|json_player| Player.from_json(json_player)}
    restored_deck = Deck.from_json(json['deck'])
    GoFish.new(restored_players, restored_deck, json['current_player_index'],
      game_id: json['game_id'])
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
    # game_go_fish = Game.find(game_id).go_fish
    # if(!game_go_fish.nil?)
    #   loaded_go_fish = GoFish.from_json(Game.find(game_id).go_fish)
    #   loaded_go_fish
    # else
    #   GoFish.new(game_id: game_id)
    # end
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

  def take_turn(player, requested_player:, requested_rank: "H")
    if(requested_player.has_card_with_rank?(requested_rank))
      won_cards = requested_player.remove_cards_with_rank(requested_rank)
      player.add_card_to_hand(won_cards)
    else
      player.draw_card(deck)
      increment_current_player_index
    end
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
end

# Method(s) I might need to add later:
# shuffle_and_deal
