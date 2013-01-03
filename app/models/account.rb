class Account < ActiveRecord::Base
	attr_accessible :name

	# association
	has_many :memberships
	has_many :users, :through => :memberships
	has_many :projects
end
