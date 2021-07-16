
RSpec.describe GoFish do
  let(:test_players) {[Player.new("John Doe"), Player.new("John Don't")]}
  let(:test_deck) {Deck.new([Card.new("8", "C")])}


  before(:each) do
    test_players[0].set_hand([Card.new("Q", "C")])
    test_players[1].send(:set_score, 2)
  end

  let(:go_fish) {GoFish.new(test_players, test_deck, 1)}

  describe('#as_json') do
    it("returns a hash with an array of each player converted to json") do
      serialized_game = go_fish.as_json
      expect(serialized_game['players']).to(eq(test_players.map(&:as_json)))
    end

    it("returns a hash with the deck converted to json") do
      serialized_game = go_fish.as_json
      expect(serialized_game['deck']).to(eq(test_deck.as_json))
    end

    it("returns a hash with the current_player_index") do
      serialized_game = go_fish.as_json
      expect(serialized_game['current_player_index']).to(eq(1))
    end
  end

  context('#add_player') do
    it("adds a player to the GoFish") do
      go_fish.add_player(Player.new("John Won't"))
      expect(go_fish.players[-1].name).to(eq("John Won't"))
    end

    it("doesn't just replace the GoFish's players array") do
      go_fish.add_player(Player.new)
      expect(go_fish.players.length).to(eq(3))
    end
  end

  context('#over?') do
    it("is true if all players have no cards and the deck is empty") do
      go_fish.players[0].set_hand([])
      go_fish.deck.send(:set_cards, [])
      expect(go_fish.over?).to(eq(true))
    end

    it("is false if the deck isn't empty") do
      go_fish.players[0].set_hand([])
      expect(go_fish.over?).to(eq(false))
    end

    it("is false if any players have any cards in their hand") do
      go_fish.deck.send(:set_cards, [])
      expect(go_fish.over?).to(eq(false))
    end
  end

  context('#set_players') do
    it("sets the players array") do
      go_fish.send(:set_players, [Player.new("John Might")])
      expect(go_fish.players.length).to(eq(1))
      expect(go_fish.players[0].name).to(eq("John Might"))
    end
  end
end
