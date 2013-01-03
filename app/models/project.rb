class Project < ActiveRecord::Base
  # attr_accessible :title, :body

	# association
	has_and_belongs_to_many :steps
	belongs_to :account

end
