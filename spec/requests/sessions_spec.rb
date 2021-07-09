require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /new" do
    it "should return new" do
      get login_path
      expect(request.path).to(eq("/login"))
    end
  end

end
