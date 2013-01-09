require 'spec_helper'

describe "Login process" do
  describe "GET /users/sign_in" do
    it "should login with a valid user" do
      user = FactoryGirl.create(:user)

      visit '/users/sign_in'
      fill_in 'Username or email', :with => user.email
      fill_in 'Password', :with => user.password
      click_button "Sign in"
      # expect(page).to have_selector("h1", :text => "Welcome to Kanban Dashboard")
      page.should have_content 'Welcome to Kanban Dashboard'
    end

    it "should refuse login with a invalid user" do
      # user = FactoryGirl.create(:user)

      visit '/users/sign_in'
      fill_in 'Username or email', :with => 'email@email.com'
      fill_in 'Password', :with => 'random'
      click_button "Sign in"
      # expect(page).to have_selector("h1", :text => "Welcome to Kanban Dashboard")
      page.should have_content 'Invalid username/email and password combination'
    end
  end
end
