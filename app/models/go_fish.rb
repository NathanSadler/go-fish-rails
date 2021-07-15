class GoFish
  attr_reader :players, :deck, :current_player_index
  def initialize(players, deck = Deck.new, current_player_index = 0)
    @players = players
    @deck = deck
    @current_player_index = current_player_index
  end

  def as_json
    { 'players' => players.map(&:as_json),
      'deck' => deck.as_json,
      'current_player_index' => current_player_index
    }
  end
end
