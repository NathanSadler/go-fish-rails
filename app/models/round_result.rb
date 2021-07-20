class RoundResult
  attr_reader :recieving_player, :expected_rank, :cards, :source

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

  def hidden_message
    return "You took no cards" if cards.empty?
    "You took #{cards.length} #{cards[0].rank}(s) from #{source_name}"
  end

  def matched_rank?
    return false if cards.empty?
    expected_rank == cards[0].rank
  end

  def source_name
    return source.name if source.is_a?(Player)
    return "the deck" if source.is_a?(Deck)
    return source
  end
end
