class Role < ActiveRecord::Base

	attr_accessible :name

	MEMBER = 'member'
	OWNER = 'owner'

	has_many :members

	scope :member, where(:name => MEMBER)
	scope :owner, where(:name => OWNER)

end
