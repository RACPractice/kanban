class Project < ActiveRecord::Base
  attr_accessible :name

	# association
	has_and_belongs_to_many :steps
	belongs_to :account

end
