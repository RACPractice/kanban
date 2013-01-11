class Role < ActiveRecord::Base
  # attr_accessible :title, :body
	attr_accessible :name

	has_many :members
	has_many :users, :through => :members
	has_many :accounts, :through => :members

end
