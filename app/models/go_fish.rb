class GoFish
  attr_reader :players, :deck, :current_player_index
  def initialize(players, deck = Deck.new, current_player_index = 0)
    @players = players
    @deck = deck
    @current_player_index = current_player_index
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

  private
    def set_players(new_players)
      @players = new_players
    end
end
