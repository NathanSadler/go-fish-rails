require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {User.new(name: "Test user", email: "user@example.com",
    password: "foobar", password_confirmation: "foobar")}

  describe("user#win, loss, and tie count") do
    before(:each) do
      user.save
      5.times {Game.create}
      Game.last(5).each {|game| GameUser.create(user_id: user.id, game_id: game.id)}
    end

    describe('user#win_count') do
      before(:each) do
        GameUser.last(3).each {|game_user| game_user.update(is_game_winner: true)}
      end

      it("returns the number of games the user won") do
        expect(user.win_count).to(eq(3))
      end

      it("doesn't count games where the user tied for first place") do
        other_user = User.create(name: "fofofo", email: "fofofo@gmail.com", password: "fofofo", password_confirmation: "fofofo")
        last_game_id = Game.last.id
        GameUser.create(user_id: other_user.id, game_id: last_game_id)
        GameUser.last.update(is_game_winner: true)
        expect(user.win_count).to(eq(2))
      end
    end

    describe('user#loss_count') do
      it("returns the number of games the user lost") do
        GameUser.first(2).each {|game_user| game_user.update(is_game_winner: false)}
        expect(user.loss_count).to(eq(2))
      end
    end

    describe('user#tie_count') do
      it("returns the number of games where the user tied for first place") do
        GameUser.last(3).each {|game_user| game_user.update(is_game_winner: true)}
        other_user = User.create(name: "fofofo", email: "fofofo@gmail.com", password: "fofofo", password_confirmation: "fofofo")
        last_game_id = Game.last.id
        other_gameuser = GameUser.create(user_id: other_user.id, game_id: last_game_id)
        GameUser.create(user_id: other_user.id, game_id: Game.first.id)
        [other_gameuser, GameUser.last].each {|gameuser| gameuser.update(is_game_winner: true)}
        expect(user.tie_count).to(eq(1))
      end
    end

  end

  describe("name") do
    it("must be present") do
      user.name = " "
      expect(user.valid?).to(eq(false))
    end

    it("must not be longer than 50 chars") do
      user.name = "A" * 51
      expect(user.valid?).to(eq(false))
    end

    it("cannot use non-ascii characters") do
      user.name = "AAAA£AAAAAA"
      expect(user.valid?).to(eq(false))
    end
  end

  it("should have an email present") do
    user.email = "  "
    expect(user.valid?).to(eq(false))
  end

  it("should not have an email longer than 255 chars") do
    user.email = ("a" * 244) + "@example.com"
    expect(user.valid?).to(eq(false))
  end

  it("accepts valid email addresses") do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                     first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user.valid?).to(eq(true))
    end
  end

  it("rejects invalid email addresses") do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user.valid?).to(eq(false))
    end
  end

  it("should have unique email addresses") do
    duplicate_user = user.dup
    user.save
    expect(duplicate_user.valid?).to(eq(false))
  end

  it("treats uppercase and lowercase characters the same when checking for "+
  "uniqueness") do
    user.email = "sample@email.com"
    duplicate_user = user.dup
    user.save
    duplicate_user.email = "SAMPLE@email.com"
    expect(duplicate_user.valid?).to(eq(false))
  end

  it("saves email addresses as lowercase") do
    test_email = "SAMPlE@emAIl.Com"
    user.email = test_email
    user.save
    expect(user.email).to(eq(test_email.downcase))
  end

  it("has a password present") do
    user.password = user.password_confirmation = " " * 6
    expect(user.valid?).to(eq(false))
  end

  it("has a password that is at least 6 characters long") do
    user.password = user.password_confirmation = "a" * 5
    expect(user.valid?).to(eq(false))
    user.password = user.password_confirmation = "a" * 6
    expect(user.valid?).to(eq(true))
  end
end
