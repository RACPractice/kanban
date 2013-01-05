class Member < ActiveRecord::Base
  attr_accessible :user_id, :account_id, :invite_sent, :member, :owner

	# associations
	belongs_to :user
	belongs_to :account

end
