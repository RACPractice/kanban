FactoryGirl.define do

  factory :role do
    trait(:owner)  { name "owner" }
    trait(:member) { name "member" }
  end
end
