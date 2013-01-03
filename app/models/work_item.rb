class WorkItem < ActiveRecord::Base
  # attr_accessible :title, :body

	# association
	belongs_to :priority
	belongs_to :step
	belongs_to :work_type
	has_many :tasks, :dependent => :destroy

end
