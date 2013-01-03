class Priority < ActiveRecord::Base
  # attr_accessible :title, :body

	# relationship
	belongs_to :work_item
end
