require 'rails_helper'

RSpec.describe "Leaderboards", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/leaderboard/index"
      expect(response).to have_http_status(:success)
    end
  end

end
