require 'rails_helper'
require 'date'

RSpec.describe "Leaderboard", type: :system do
  let(:session) {Capybara::Session.new(:rack_test, Rails.application)}

  before(:each) do
    User.first.destroy
    ["lalala", "sasasa", "teeteetee"].each {|name| User.create(name: name, email: "#{name}@gmail.com", password: name, password_confirmation: name)}
    3.times {Game.create()}
    Game.all.each do |game|
      User.all.each {|user| GameUser.create(game_id: game.id, user_id: user.id)}
      game.update(started_at: DateTime.new(2021, 07, 29, 12, 0, 0), finished_at: DateTime.new(2021, 07, 29, 12, 10, 0))
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
      Game.last.update(started_at: DateTime.new(2021, 07, 29, 12, 0, 0), finished_at: DateTime.new(2021, 07, 29, 12, 10, 0))
      go_to_leaderboard(session)
    end

    it("lists the user's name") do
      user_names = session.all(:css, 'td:nth-child(2)')
      expect(user_names[0].text).to(eq("sasasa"))
    end

    it("lists the number of games the user won") do
      won_games_count = session.first(:css, 'td:nth-child(3)')
      expect(won_games_count.text).to(eq("3"))
    end

    it("lists the number of games the user played") do
      played_games_count = session.first(:css, 'td:nth-child(4)')
      expect(played_games_count.text).to(eq("4"))
    end

    it("lists the time the user has spend in game with the format days:hours:minutes:seconds") do
      game_time = session.first(:css, 'td:nth-child(5)')
      expect(game_time.text).to(eq("0:0:30:0"))
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