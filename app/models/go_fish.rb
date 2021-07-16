class GoFish
  attr_reader :players, :deck, :current_player_index
  def initialize(players, deck = Deck.new, current_player_index = 0, game_user_id: 0)
    @players = players
    @deck = deck
    @current_player_index = current_player_index
    @game_user_id = game_user_id
  end

  def add_player(player)
    set_players(players.push(player))
  end

  def as_json
    { 'players' => players.map(&:as_json),
      'deck' => deck.as_json,
      'current_player_index' => current_player_index
    }
  end

  def deal_cards
    players.length > 3 ? (card_deal_count = 5) : (card_deal_count = 7)
    card_deal_count.times do
      players.each {|player| player.add_card_to_hand(deck.draw_card)}
    end
  end

  def increment_current_player_index
    set_current_player_index(current_player_index + 1)
  end

  def over?
    cards_in_hands = players.map(&:hand).map(&:length).sum
    (cards_in_hands == 0) && (deck.empty?)
  end

  def turn_player
    players[current_player_index]
  end

  private
    def set_current_player_index(new_value)
      @current_player_index = new_value % players.length
    end

    def set_players(new_players)
      @players = new_players
    end
end

# Method(s) I might need to add later:
# shuffle_and_deal
