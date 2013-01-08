class WorkItem < ActiveRecord::Base
  attr_accessible :name, :slug, :description, :project_id, :work_type_id, :priority_id, :step_id,
									:work_value, :is_ready, :is_blocked, :assigned_to, :target_date

	before_create :create_slug

	# association
	belongs_to :priority
	belongs_to :step
	belongs_to :work_type
	has_many :tasks, :dependent => :destroy

	# Generates the Slug field
	def create_slug
		self.slug = self.name.parameterize
	end

end
