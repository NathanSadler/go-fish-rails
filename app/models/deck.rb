require_relative 'card'
class Deck
  attr_reader :cards, :cards_dealt

  def initialize(specified_cards=Deck.default_deck)
    @cards = specified_cards
    @cards_dealt = false
  end

  def self.default_deck
    ranks = (2..10).to_a.concat(["A", "J", "Q", "K"])
    suits = ["S", "D", "H", "C"]
    card_list = []
    ranks.each do |rank|
      suits.each {|suit| card_list.push(Card.new(rank, suit))}
    end
    card_list
  end

  def cards_dealt?
    cards_dealt
  end

  def shuffle
    cards.shuffle!
  end

  def set_cards_dealt(new_value)
    @cards_dealt = new_value
  end

  def draw_card
    cards.shift
  end

  def cards_in_deck
    cards.length
  end

  def self.cards_in_default_deck
    Deck.new.cards_in_deck
  end

  def empty?
    cards_in_deck == 0
  end

  def as_json(*)
    {"cards" => cards.map(&:as_json)}
  end

  def self.from_json(json)
    Deck.new(json["cards"].map {|json_card| Card.from_json(json_card)})
  end

  private
  def set_cards(new_cards)
    @cards = new_cards
  end

end
