require 'rails_helper'

RSpec.describe "Games", type: :request do
  describe "GET /index" do
    before(:each) do
      Game.create(title:"Test Game")
      Game.create(title:"Hello World")
    end

    after(:each) do
      Game.delete_all
    end

    it "returns http success" do
      get "/games/"
      expect(response).to have_http_status(:success)
    end

    it "lists links to all games" do
      get "/games/"
      Game.all.each do |game|
        assert_select "a[href=?]", game_path(game), count: 1
      end
    end
  end
end
