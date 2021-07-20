class RoundResult
  attr_reader :recieving_player, :expected_rank, :source, :cards

  def initialize(cards:, recieving_player:, expected_rank: "none given",
    source: "an unspecified source")
    @cards = cards
    @recieving_player = recieving_player
    @expected_rank = expected_rank.to_s
    @source = source
  end

  def card_to_array(card)
    
  end
end
