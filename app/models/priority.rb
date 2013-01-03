class Priority < ActiveRecord::Base
  attr_accessible :name

	# association
	belongs_to :work_item
end
