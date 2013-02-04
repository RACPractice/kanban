# This will guess the Account class
FactoryGirl.define do

  factory :account do
    name { Forgery::Name.full_name }
    description { Forgery::LoremIpsum.sentence }
  end
end