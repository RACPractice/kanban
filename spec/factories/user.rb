# This will guess the User class
FactoryGirl.define do

  factory :user do
    username "john"
    email  "kanban@kanbab.com"
    password 'test_password'
  end

end