require 'rails_helper'
require 'pry'

RSpec.describe "Users", type: :request do
# Don't confuse this with #index, which lists all of the users
describe "GET /show/:id" do
    let!(:test_user) {User.create(name: "Test User", email: "user@example.com",
      password: "foobar", password_confirmation: "foobar")}

    before(:each) do
      get user_path(test_user)
    end

    it "displays the user's name" do
      expect(response.body.include?("<h1>Test User")).to(be(true))
    end

    it "displays the user's email" do
      expect(response.body.include?("user@example.com")).to(eq(true))
    end
  end
end
