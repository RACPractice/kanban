# This will guess the User class
FactoryGirl.define do

  factory :user do
    username "john"
    email  "kanban@kanbab.com"
    password 'test_password'
  end

  # This will use the User class (Admin would have been guessed)
  # factory :admin, class: User do
  #   first_name "Admin"
  #   last_name  "User"
  #   admin      true
  # end
end