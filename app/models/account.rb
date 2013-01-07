class Account < ActiveRecord::Base
	attr_accessible :name, :slug
	before_create :create_slug

	# validations
	validates :name, :presence => true, :uniqueness => true

	# association
	has_many :members
	has_many :users, :through => :members
	has_many :projects

	# Generates the Slug field
	def create_slug
		self.slug = self.name.parameterize
	end

end
