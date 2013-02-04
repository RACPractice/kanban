# This will guess the User class
FactoryGirl.define do
  sequence(:email) {|n| "person-#{n}@example.com" }

  factory :user do
    username { Forgery::Name.first_name }
    email
    password 'test_password'
  end

end