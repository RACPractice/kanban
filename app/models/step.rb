class Step < ActiveRecord::Base
  # attr_accessible :title, :body

	# relationship
	has_many :projects
end
