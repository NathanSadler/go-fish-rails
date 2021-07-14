require 'rails_helper'
require 'pry'

RSpec.describe "SiteLayouts", type: :request do
  describe "GET /site_layouts" do
    fixtures :users
    let(:test_user) {users(:michael)}

    it "displays the login link if the user isn't logged in" do
      get root_path
      assert_select "a[href=?]", login_path
    end

<<<<<<< HEAD
    it "displays the settings link if the user isn't logged in" do
      # Add stuff here later
=======
    xit "displays a logout link if the user is logged in" do
      get login_path
      post login_path, params: { session: {email: test_user.email,
        password: test_user.password}}
      binding.pry
      assert_select "a[href=?]", logout_path
>>>>>>> game-models
    end
  end
end
