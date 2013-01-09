class Member < ActiveRecord::Base

  #ACCESSORS
  attr_accessible :user_id, :account_id, :invite_sent, :member, :owner

	#ASSOCIATIONS
	belongs_to :user
	belongs_to :account

  #METHODS

end
