class Project < ActiveRecord::Base
  # attr_accessible :title, :body

	#relationship
	has_many :steps
end
