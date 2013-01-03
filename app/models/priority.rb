class Priority < ActiveRecord::Base
  attr_accessible :name
  validates :name, :presence => true, :uniqueness => true

	# association
	belongs_to :work_item
end
