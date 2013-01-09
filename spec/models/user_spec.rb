require 'spec_helper'

describe User do
  describe 'CRUD operations:' do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    #Test presence of indexes
    it {should have_db_index(:username)}
    it {should have_db_index(:email)}
    it {should have_db_index(:reset_password_token)}

    #Test associations
    it {should have_many(:members)}
    it {should have_many(:accounts)}

    #Test validations
    it {should validate_presence_of(:email)}
    it {should validate_uniqueness_of(:email)}
    it {should validate_presence_of(:password)}
    it {should validate_confirmation_of(:password)}
    it {should_not allow_value('test').for(:email)}
    it {should allow_value('test@test.com').for(:email)}

    #Test mass assignment
    # it {should_not allow_mass_assignment_of(:password)}

    #Custom tests with rspec assertions
    it "should create and save a new instance of user" do
      # user = FactoryGirl.create(:user)
      expect(User.first).to eq(@user)
      @user.id.should_not be_nil
    end

    it 'should have one user in database' do
      expect(User.count).to eq(1)
    end
  end
end