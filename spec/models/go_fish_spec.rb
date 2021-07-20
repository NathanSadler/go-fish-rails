require 'rails_helper'

RSpec.describe GoFish do
  let!(:test_user) {User.first}
  let!(:test_user2) {User.create(name: "Test User", email: "test@user.com",
    password: "password", password_confirmation: "password")}
  let(:test_players) {[Player.new("John Doe", test_user.id), Player.new("John Don't",
    test_user2.id)]}
  let(:test_deck) {Deck.new([Card.new("8", "C")])}


  before(:each) do
    game = Game.create
    test_players[0].set_hand([Card.new("Q", "C")])
    test_players[1].send(:set_score, 2)
    test_players.each {|player| game.add_player(player)}
    game.set_deck(test_deck.cards)
    GameUser.create(game_id: Game.last.id, user_id: test_user.id)
    GameUser.create(game_id: Game.last.id, user_id: test_user2.id)
  end

  after(:each) do
    Game.last.destroy
    2.times {GameUser.last.destroy}
  end

  let(:go_fish) {GoFish.new(test_players, test_deck, 1)}

  # Make it so that it uses an actual hash to test for

  context('#add_player') do
    it("adds a player to the GoFish") do
      go_fish.add_player(Player.new("John Won't"))
      expect(go_fish.players[-1].name).to(eq("John Won't"))
    end

    it("doesn't just replace the GoFish's players array") do
      go_fish.add_player(Player.new)
      expect(go_fish.players.length).to(eq(3))
    end

    xit("won't add players once the game starts") do

    end
  end

  describe('#as_json') do
    let!(:serialized_game) {go_fish.as_json}

    it("returns a hash with an array of each player converted to json") do
      expect(serialized_game['players'][0]['name']).to(eq("John Doe"))
    end

    it("returns a hash with the deck converted to json") do
      expect(serialized_game['deck']['cards'][0]).to(eq({"rank" => "8", "suit" => "C"}))
    end

    it("returns a hash with the current_player_index") do
      expect(serialized_game['current_player_index']).to(eq(1))
    end

    it("returns a hash with the ID of the Game Object associated with it") do
      expect(serialized_game['game_id']).to(eq(0))
    end
  end

  context('#deal_cards') do
    before(:each) do
      go_fish.players[0].set_hand([])
      go_fish.deck.send(:set_cards, Deck.default_deck)
    end

    it("gives 7 cards to each player if there are 3 or fewer players") do
      go_fish.add_player(Player.new)
      go_fish.deal_cards
      go_fish.players.each {|fisher| expect(fisher.hand.length).to(eq(7))}
    end

    it("gives 5 cards to each player if there are more than 3 players") do
      2.times {go_fish.add_player(Player.new)}
      go_fish.deal_cards
      go_fish.players.each {|fisher| expect(fisher.hand.length).to(eq(5))}
    end

    it("doesn't make the mistake of giving multiple players the same hand") do
      go_fish.deal_cards
      expect(go_fish.players[0].hand).to_not(eq(go_fish.players[1].hand))
    end

    it("removes cards from the deck") do
      go_fish.deal_cards
      expect(go_fish.deck.cards_in_deck).to(eq(38))
    end

    # TODO: make it so that dealing cards is what considers the game to begin
      #started instead of players joinging
  end

  context('#find_player_with_user_id') do
    before(:each) do
      new_id = 1
      go_fish.players.each do |go_fish_player|
        go_fish_player.send(:set_user_id, new_id)
        new_id += 1
      end
    end

    it("returns a player with a given user_id") do
      expect(go_fish.find_player_with_user_id(1)).to(eq(go_fish.players[0]))
    end

    it("returns nil if there is no player with a matching id") do
      expect(go_fish.find_player_with_user_id(0)).to(eq(nil))
    end
  end

  context('.from_json') do
    let(:json_go_fish) {go_fish.as_json}
    let(:restored_go_fish) {GoFish.from_json(json_go_fish)}

    it("builds a go_fish game from a json hash") do
      expect(restored_go_fish.players.map(&:name)).to(eq(go_fish.players.map(&:name)))
      expect(restored_go_fish.deck.cards).to(eq(go_fish.deck.cards))
      #binding.pry
      expect(restored_go_fish.current_player_index).to(eq(go_fish.current_player_index))
      expect(restored_go_fish.game_id).to(eq(go_fish.game_id))
    end
  end

  context('#increment_current_player_index') do
    it("increases the turn counter by one") do
      go_fish.add_player(Player.new)
      go_fish.increment_current_player_index
      expect(go_fish.current_player_index).to(eq(2))
    end

    it("goes back to 0 if it goes back to the last player") do
      go_fish.increment_current_player_index
      expect(go_fish.turn_player).to(eq(test_players[0]))
    end
  end

  context('#list_cards_of_player_with_user_id') do
    let(:expected_cards) {[Card.new("8", "H"), Card.new("9", "D")]}
    before(:each) do
      new_id = 0
      go_fish.players.each do |player|
        player.send(:set_user_id, new_id)
        new_id += 1
      end
      go_fish.players[0].send(:set_hand, expected_cards)
    end

    it("returns the list of cards of a player with a given user_id") do
      player_cards = go_fish.list_cards_of_player_with_user_id(0)
      expect(player_cards).to(eq(expected_cards))
    end
  end

  context('.load') do
    before(:each) do
      go_fish.send(:set_game_id, Game.last.id)
      go_fish.save
    end

    it("loads a go_fish object using the go_fish column from a record in the "+
    "Games table") do
      game = Game.last
      expect(game.players.map(&:name)).to(eq(go_fish.players.map(&:name)))
      expect(game.deck.cards).to(eq(go_fish.deck.cards))
    end

    context("the Game object's go_fish column is nil") do
      before(:each) do
        Game.create
      end

      after(:each) do
        Game.last.destroy
      end

      let(:game) {Game.last}
      let(:default_go_fish) {GoFish.new}

      it("uses the default values for all other attributes") do
        expect(game.players).to(eq(default_go_fish.players))
        expect(game.deck.cards).to(eq(default_go_fish.deck.cards))
        expect(game.current_player_index).to(eq(
          default_go_fish.current_player_index))
      end
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

  context('#set_current_player_index') do
    it("returns the remainder of the given value divided by the number of "+
    "players") do
      go_fish.add_player(Player.new)
      expect(go_fish.send(:set_current_player_index, 4)).to(eq(1))
    end
  end

  context('#set_game_id') do
    it("sets the game_id") do
      go_fish.send(:set_game_id, 12)
      expect(go_fish.game_id).to(eq(12))
    end
  end

  context('#set_players') do
    it("sets the players array") do
      go_fish.send(:set_players, [Player.new("John Might")])
      expect(go_fish.players.length).to(eq(1))
      expect(go_fish.players[0].name).to(eq("John Might"))
    end
  end

  context('#take_turn') do
    before(:each) do
      go_fish.players[1].send(:set_hand, [Card.new("Q", "D")])
    end

    it("increments the current_player_index") do
      go_fish.add_player(Player.new)
      go_fish.take_turn(go_fish.turn_player, requested_player: go_fish.players[0])
      expect(go_fish.current_player_index).to(eq(2))
    end

    it("lets one player take card(s) of a specified rank from another player") do
      go_fish.take_turn(go_fish.players[1], requested_player: go_fish.players[0],
        requested_rank: "Q")
      expect(go_fish.players[1].hand).to(eq([Card.new("Q", "D"), Card.new("Q", "C")]))
      expect(go_fish.players[0].hand.length).to(eq(0))
    end

    it("doesn't have a player draw a card from the deck if they get card(s) "+
  "of a rank they ask for from another player") do
    go_fish.take_turn(go_fish.players[1], requested_player: go_fish.players[0],
      requested_rank: "Q")
    expect(go_fish.players[1].hand.include?(Card.new("8", "C"))).to(be(false))
  end
  end

  context('#turn_player') do
    it("returns the player whose turn it is") do
      expect(go_fish.turn_player).to(eq(test_players[1]))
    end
  end
end
