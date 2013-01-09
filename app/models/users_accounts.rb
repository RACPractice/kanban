class UsersAccounts < ActiveRecord::Base
  #ACCESSORS
  # attr_accessible :title, :body

  #ASSOCIATIONS
	belongs_to :user
	belongs_to :account
end
