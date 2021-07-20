class RoundResult
  attr_reader :recieving_player, :expected_rank, :source, :cards

  def initialize(cards:, recieving_player:, expected_rank: "none given",
    source: "an unspecified source")
    @cards = card_to_array(cards)
    @recieving_player = recieving_player
    @expected_rank = expected_rank.to_s
    @source = source
  end

  def card_to_array(card)
    return card if card.is_a?(Array)
    [card]
  end
end
