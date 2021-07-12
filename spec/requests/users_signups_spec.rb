require 'rails_helper'
require_relative '../helpers/users_helper_spec'

RSpec.describe "UsersSignups", type: :request do
  describe "GET /users_signups" do
    it "doesn't accept invalid submissions" do
      get signup_path
      assert_no_difference 'User.count' do
        post users_path, params: { user: {name: " ", email: "user@invalid",
          password: "foo", password_confirmation: "bar"}}
      end
    end
    it "accepts valid submissions" do
      get signup_path
      assert_difference 'User.count', 1 do
        post users_path, params: { user: {name: "Example User",
          email: "user@example.com", password: "password", password_confirmation: "password"}}
      end
      follow_redirect!
      expect(request.path).to(eq("/users/#{User.last.id}"))
      assert is_logged_in?
    end
  end
end
