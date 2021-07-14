require 'rails_helper'

def login
  visit login_path
  fill_in 'Email', with: "foo@bar.com"
  fill_in "Password", with: "foobar"
  click_on "Submit"
end

RSpec.describe 'create game', type: :system do
  before(:each) do
    User.create(name:"foobar", email:"foo@bar.com", password:"foobar", password_confirmation:"foobar")
  end

  after(:each) do
    User.destroy_all
  end

  scenario("a logged-in user") do
    login
    visit new_game_path
    fill_in 'Title', with: "Automated Test Game"
    click_on "Submit"
    expect(Game.last.title).to(eq("Automated Test Game"))
  end
end
