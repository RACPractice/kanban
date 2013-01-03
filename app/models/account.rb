class Account < ActiveRecord::Base
	attr_accessible :name

	# association
	has_many :members
	has_many :users, :through => :members
	has_many :projects
end
