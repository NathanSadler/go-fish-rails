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
