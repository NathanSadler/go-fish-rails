require 'rails_helper'

RSpec.describe "SiteLayouts", type: :request do
  describe "GET /site_layouts" do
    it "displays the login link if the user isn't logged in" do
      get root_path
      assert_select "a[href=?]", login_path
    end
  end
end
