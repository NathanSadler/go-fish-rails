
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
end
