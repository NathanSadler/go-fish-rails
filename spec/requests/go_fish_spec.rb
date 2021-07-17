require 'rails_helper'

RSpec.describe "GoFishes", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/go_fish/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/go_fish/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
