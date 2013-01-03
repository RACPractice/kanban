class Priority < ActiveRecord::Base
  attr_accessible :name
	before_create :create_slug

 	# association
	belongs_to :work_item

	# validations
	validates :name, :presence => true, :uniqueness => true

	# Generates the Slug field
	def create_slug
		self.slug = self.name.parameterize
	end

end
