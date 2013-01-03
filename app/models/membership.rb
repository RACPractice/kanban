class Membership < ActiveRecord::Base
  # attr_accessible :title, :body

	# associations
	belongs_to :user
	belongs_to :account
end
