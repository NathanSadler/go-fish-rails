require 'rails_helper'
require 'pry'

RSpec.describe "Sessions", type: :request do
  describe "GET /new" do
    it "should return new" do
      get login_path
      expect(request.path).to(eq("/login"))
    end
  end
end

RSpec.describe "Sessions", type: :feature do
  describe "logging in" do
    it('directs users to their info page when logging in') do
      visit login_path
      binding.pry
      fill_in '_login_email', with: 'michael@example.com'
      fill_in '_login_password', with: 'foobar'
      click_on "Submit"
    end
    it('redirects users to the login page if they enter invalid info') do
      #binding.pry
      #debugger
      visit login_path
      fill_in '_login_email', with: 'bob@example.com'
      fill_in '_login_password', with: 'c'
      click_on "Submit"
      expect(1 == 2).to(eq(true))
    end
  end
end
