require 'rails_helper'
require 'pry'

RSpec.describe "Users", type: :request do
  describe "GET /new" do
    it "returns the signup page" do
      get signup_path
      expect(request.path).to(eq('/signup'))
    end
  end
end

RSpec.describe "Users", type: :feature do
  let!(:test_user) {User.create(name: "Test User", email: "michael@example.com",
    password: "foobar", password_confirmation: "foobar")}

  describe "logging in" do
    it('directs users to their info page when logging in') do
      visit login_path
      fill_in 'session_email', with: 'michael@example.com'
      fill_in 'session_password', with: 'foobar'
      click_on "Submit"
      expect(current_path).to(eq("/users/#{User.last.id}"))
    end

    it('redirects users to the login page if they enter invalid info') do
      visit login_path
      fill_in 'session_email', with: 'bob@example.com'
      fill_in 'session_password', with: 'c'
      click_on "Submit"
      expect(current_path).to(eq("/login"))
    end
  end
end
