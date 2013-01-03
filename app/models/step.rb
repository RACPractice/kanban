class Step < ActiveRecord::Base
  # attr_accessible :title, :body

	# association
	has_and_belongs_to_many :projects
end
