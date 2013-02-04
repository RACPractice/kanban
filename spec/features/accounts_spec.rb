require 'spec_helper'

describe "Accounts management" do

  before(:each) do
    FactoryGirl.create(:role)
    # Log in
    @user = FactoryGirl.create(:user)
    visit '/users/sign_in'
    fill_in 'Username or email', :with => @user.email
    fill_in 'Password', :with => @user.password
    click_button "Sign in"
  end

  it "should create a new owned account" do
    pending
    visit new_account_path
    fill_in 'Name', :with => 'AnAccount'
    click_button "Create Account"
    page.should have_content 'AnAccount'
  end
end
