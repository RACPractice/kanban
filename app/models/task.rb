class Task < ActiveRecord::Base
  attr_accessible :name, :description, :work_item_id
	before_create :create_slug

	# association
	belongs_to :work_item

	# Generates the Slug field
	def create_slug
		self.slug = self.name.parameterize
	end

end
