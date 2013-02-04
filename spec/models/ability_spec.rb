require 'spec_helper'
require "cancan/matchers"

describe Ability do
  before(:each) do
    @role_owner = FactoryGirl.create(:role, :owner)
    @role_member = FactoryGirl.create(:role, :member)
  end

  describe "owner" do
    before(:each) do
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      @project1 = FactoryGirl.create(:project)
      @user1.members.build account: @project1.account, role: @role_owner
    end

    it "should allow management of own account" do
      ability1 = Ability.new(@user1)
      ability1.should be_able_to(:manage, @project1.account)
    end

    it "should not allow management of other's account" do
      ability2 = Ability.new(@user2)
      ability2.should_not be_able_to(:manage, @project1.account)
    end

  end

  describe "member" do
    before(:each) do
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      @project1 = FactoryGirl.create(:project)
      @project2 = FactoryGirl.create(:project)
      @user1.members.build account: @project1.account, role: @role_owner
      @user2.members.build account: @project1.account, role: @role_member
    end

    it "should allow management of own projects" do
      ability1 = Ability.new(@user1)
      ability1.should be_able_to(:manage, @project1)
    end

    it "should allow management of projects I am a member of" do
      ability2 = Ability.new(@user2)
      ability2.should be_able_to(:manage, @project1)
    end

    it "should not allow management of other's projects" do
      puts "Project 1 account: #{@project1.account.id}"
      puts "Project 2 account: #{@project2.account.id}"
      ability1 = Ability.new(@user1)
      ability1.should_not be_able_to(:manage, @project2)
    end
  end

end
