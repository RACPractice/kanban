class Account < ActiveRecord::Base
  # attr_accessible :title, :body

	# relationship
	has_many :users_accounts
	has_many :users, :through => :users_accounts
end
