class Player
  attr_reader :name, :hand, :score, :user_id

  def initialize(name = "Player", user_id = 0)
    @name = name
    @hand = []
    @score = 0
    @user_id = user_id
  end

  def self.from_json(json)
    restored_player = Player.new(json['name'], json['user_id'])
    restored_player.increase_score(json['score'])
    restored_player.set_hand(json['hand'].map {
      |json_card| Card.from_json(json_card)})
    restored_player
  end

  def add_card_to_hand(card)
    if(card.is_a?(Array))
      set_hand(hand.concat(card))
      card
    else
      set_hand(hand.push(card))
      [card]
    end
  end

  def as_json
    {
      'name' => name, 'score' => score,
      'hand' => hand.map(&:as_json), 'user_id' => user_id
    }
  end

  def draw_card(deck)
    taken_card = deck.draw_card
    add_card_to_hand(taken_card)
    taken_card
  end

  def find_book_ranks
    occurences = {}
    hand.each do |card|
      occurences[card.rank] ? occurences[card.rank] += 1 : occurences[card.rank] = 1
    end
    occurences.keys.select {|rank| occurences[rank] == 4}
  end

  def has_card?(card)
    hand.include?(card)
  end

  def has_card_with_rank?(rank)
    (hand.select {|card| card.rank == rank}).length > 0
  end

  def increase_score(points)
    set_score(score + points)
  end

  def lay_down_books
    book_ranks = find_book_ranks
    books = hand.select {|card| book_ranks.include?(card.rank)}
    increase_score(books.length / 4)
    books.each do |card|
      remove_card_from_hand(card)
    end
  end

  def remove_card_from_hand(card)
    if self.hand.include?(card)
      set_hand(self.hand.reject {|hand_card| hand_card == card})
      return card
    else
      return nil
    end
  end

  def remove_cards_with_rank(rank)
    cards_to_remove = hand.select {|card| card.rank == rank}
    set_hand(hand - cards_to_remove)
    cards_to_remove
  end

  def set_hand(new_hand)
    @hand = new_hand
  end

  private
    def set_score(new_score)
      @score = new_score
    end

    # only to be used in tests!
    def set_user_id(new_id)
      @user_id = new_id
    end

end
