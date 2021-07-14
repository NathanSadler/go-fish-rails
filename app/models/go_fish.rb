class GoFish
  attr_reader :players, :deck
  def initialize(players, deck = Deck.new, current_player_index = 0)
    @players = players
    @deck = deck
    @current_player_index = current_player_index
  end

  #NOTE: start with a basic thing that doesn't change at all
end
