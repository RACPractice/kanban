class WorkType < ActiveRecord::Base
  attr_accessible :name
	before_create :create_slug

  # Validations
	validates :name, :presence => true, :uniqueness => true

  # Generates the Slug field
	def create_slug
		self.slug = self.name.parameterize
	end

end
