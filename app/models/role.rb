class Role < ActiveRecord::Base
	#ACCESSORS
	attr_accessible :name

	#ASSOCIATIONS
	has_and_belongs_to_many :users

end
