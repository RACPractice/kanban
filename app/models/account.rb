class Account < ActiveRecord::Base
  # attr_accessible :title, :body

	# association
	has_many :users_accounts
	has_many :users, :through => :users_accounts
	has_many :projects
end
