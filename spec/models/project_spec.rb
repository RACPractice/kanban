require 'spec_helper'

describe Project do
  before(:each) do
    @project = FactoryGirl.create(:project)
  end

  #Test presence of indexes
  it {should have_db_index(:slug)}
  it {should have_db_index(:account_id)}

  #Test associations
  it {should have_and_belong_to_many(:steps)}
  it {should belong_to(:account)}

  #Test validations
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:slug)}
  it {should validate_uniqueness_of(:slug)}
  it {should validate_presence_of(:account_id)}

  #Test mass assignment
  it {should_not allow_mass_assignment_of(:slug)}

  #Custom tests with rspec assertions
  it "should create and save a new instance of project" do
    expect(Project.first).to eq(@project)
    @project.id.should_not be_nil
  end

  it 'should count correctly projects in database' do
    FactoryGirl.create(:project)
    expect(Project.count).to eq(2)
  end
end
