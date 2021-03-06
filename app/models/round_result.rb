class RoundResult
  attr_reader :recieving_player, :expected_rank, :cards, :source, :round_results, :asked_player

  def initialize(cards:, recieving_player:, expected_rank: "none given",
    source: "an unspecified source", asked_player: Player.new("Nobody"))
    @cards = card_to_array(cards)
    @recieving_player = recieving_player
    @expected_rank = expected_rank.to_s
    @source = source
    @asked_player = asked_player
  end

  def as_json
    {
      "cards" => cards.map(&:as_json), "expected_rank" => expected_rank,
      "recieving_player" => recieving_player.as_json,
      "source" => source.as_json, "asked_player" => asked_player.as_json
    }
  end

  def card_to_array(card)
    return card if card.is_a?(Array)
    [card]
  end

  def self.from_json(json)
    restored_cards = (json["cards"].reject {|card| card.nil?}).map{|json_card| Card.from_json(json_card)}
    restored_reciever = Player.from_json(json["recieving_player"])
    restored_asked_player = Player.from_json(json["asked_player"])
    json["source"].is_a?(Hash) ? restored_source = Player.from_json(json["source"]) : restored_source = json["source"]
    RoundResult.new(cards: restored_cards, expected_rank: json["expected_rank"],
    recieving_player: restored_reciever, source: restored_source, asked_player: restored_asked_player)
  end

  def hidden_message
    return "You took no cards" if cards.empty?
    "You took #{cards.length} #{cards[0].rank}(s) from #{source_name}"
  end

  def matched_rank?
    return false if (cards.empty? || cards[0].nil?)
    expected_rank == cards[0].rank
  end

  def message_start
    return "#{recieving_player.name} asked #{asked_player.name} for #{expected_rank}s"
  end

  def public_message
    return "#{message_start} and took no cards" if cards.empty?
    return "#{message_start} and took #{cards.length} #{matched_rank? ? cards[0].rank : "card"}(s)" if source.is_a?(Player)
    "#{message_start} and took #{cards.length} #{matched_rank? ? cards[0].rank : "card"}(s) from #{source_name}"
  end

  def source_name
    return source.name if source.is_a?(Player)
    return "the deck" if source.is_a?(Deck)
    return source
  end
end
