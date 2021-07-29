require 'rails_helper'

RSpec.describe "Leaderboard", type: :system do
  let(:session) {Capybara::Session.new(:rack_test, Rails.application)}

  before(:each) do
    User.first.destroy
    ["lalala", "sasasa", "teeteetee"].each {|name| User.create(name: name, email: "#{name}@gmail.com", password: name, password_confirmation: name)}
    3.times {Game.create()}
    Game.all.each do |game|
      User.all.each {|user| GameUser.create(game_id: game.id, user_id: user.id)}
    end
  end

  let(:test_user_a) {User.all[0]} # lalala
  let(:test_user_b) {User.all[1]} # sasasa
  let(:test_user_c) {User.all[2]} # teeteetee

  describe("listing user information") do
    before(:each) do
      GameUser.where(user_id: test_user_b.id).each {|gameuser| gameuser.update(is_game_winner: true)}
      Game.create
      [test_user_a, test_user_b].each {|user| GameUser.create(game_id: Game.last.id, user_id: user.id)}
      go_to_leaderboard(session)
    end

    it("lists the user's name") do
      user_names = session.all(:css, 'td:nth-child(2)')
      expect(user_names[0]).to(eq("sasasa"))
    end

    it("lists the number of games the user won") do
      won_games_count = session.first(:css, 'td:nth-child(3)')
      expect(won_games_count).to(eq(2))
    end

    it("lists the number of games the user played") do
      played_games_count = session.first(:css, 'td:nth-child(4)')
      expect(won_games_count).to(eq(3))
    end
  end

  describe("ordering users") do
    it("lists users by number of games won in descending order") do
      GameUser.where(user_id: test_user_b.id).each {|gameuser| gameuser.update(is_game_winner: true)}
      go_to_leaderboard(session)
      user_names = session.all(:css, 'td:nth-child(2)')
      expect(user_names[0].text).to(eq(test_user_b.name))
    end

    it("includes users that haven't won any games") do
      GameUser.where(user_id: test_user_b.id).each {|gameuser| gameuser.update(is_game_winner: true)}
      go_to_leaderboard(session)
      expect(session).to(have_content("sasasa"))
      expect(session).to(have_content("teeteetee"))
    end

  end
end