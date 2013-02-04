# This will guess the Project class
FactoryGirl.define do
  sequence(:account) {|n| FactoryGirl.create(:account) }

  factory :project do
    name "first_project"
    description "Project description"
    account
  end
end
