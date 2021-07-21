class RoundResult
  attr_reader :recieving_player, :expected_rank, :cards, :source, :round_results

  def initialize(cards:, recieving_player:, expected_rank: "none given",
    source: "an unspecified source")
    @cards = card_to_array(cards)
    @recieving_player = recieving_player
    @expected_rank = expected_rank.to_s
    @source = source
  end

  def as_json
    {
      "cards" => cards.map(&:as_json), "expected_rank" => expected_rank,
      "recieving_player" => recieving_player.as_json,
      "source" => source_name
    }
  end

  def card_to_array(card)
    return card if card.is_a?(Array)
    [card]
  end

  def self.from_json(json)
    restored_cards = json["cards"].map{|json_card| Card.from_json(json_card)}
    restored_reciever = Player.from_json(json["recieving_player"])
    RoundResult.new(cards: restored_cards, expected_rank: json["expected_rank"],
    recieving_player: restored_reciever, source: json["source"])
  end

  def hidden_message
    return "You took no cards" if cards.empty?
    "You took #{cards.length} #{cards[0].rank}(s) from #{source_name}"
  end

  def matched_rank?
    return false if cards.empty?
    expected_rank == cards[0].rank
  end

  def public_message
    return "#{recieving_player.name} took no cards from #{source_name}" if cards.empty?
    ("#{recieving_player.name} took #{cards.length} #{matched_rank? ? cards[0].rank : "card"}(s) " +
    "from #{source_name}")
  end

  def source_name
    return source.name if source.is_a?(Player)
    return "the deck" if source.is_a?(Deck)
    return source
  end
end
