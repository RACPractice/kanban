# This will guess the Project class
FactoryGirl.define do

  factory :project do
    name "first_project"
    description "Project description"
    account FactoryGirl.create(:account)
  end
end
