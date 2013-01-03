class Priority < ActiveRecord::Base
  # attr_accessible :title, :body

	# association
	belongs_to :work_item
end
