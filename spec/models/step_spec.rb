require 'spec_helper'

describe Step do
  before(:each) do
    @step = FactoryGirl.create(:step)
  end

  #Test presence of indexes
  it {should have_db_index(:slug)}

  #Test associations
  it {should have_and_belong_to_many(:projects)}

  #Test validations
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:slug)}
  it {should validate_uniqueness_of(:slug)}

  #Test mass assignment
  it {should_not allow_mass_assignment_of(:slug)}

  #Custom tests with rspec assertions
  it "should create and save a new instance of step" do
    expect(Step.first).to eq(@step)
    @step.id.should_not be_nil
  end

  it 'should count correctly steps in database' do
    FactoryGirl.create(:step)
    expect(Step.count).to eq(2)
  end
end
