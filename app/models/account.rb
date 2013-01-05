class Account < ActiveRecord::Base
	attr_accessible :name, :slug
	before_create :create_slug

	# association
	has_many :members
	has_many :users, :through => :members
	has_many :projects

	#has_many :user

	# Generates the Slug field
	def create_slug
		self.slug = self.name.parameterize
	end

end
