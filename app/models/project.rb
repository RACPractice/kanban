class Project < ActiveRecord::Base
  attr_accessible :name, :description, :account_id, :visible
	before_create :create_slug

	# association
	has_and_belongs_to_many :steps
	belongs_to :account

	# Generates the Slug field
	def create_slug
		self.slug = self.name.parameterize
	end


end
