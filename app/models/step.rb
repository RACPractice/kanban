class Step < ActiveRecord::Base
	attr_accessible :name, :anchor, :capacity, :position
	before_create :create_slug

	# association
	has_and_belongs_to_many :projects

	# Generates the Slug field
	def create_slug
		self.slug = self.name.parameterize
	end

end
