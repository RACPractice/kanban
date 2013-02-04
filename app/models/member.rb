class Member < ActiveRecord::Base

  #ACCESSORS
  attr_accessible :user_id, :account_id, :role_id, :invite_sent, :account, :role

	#ASSOCIATIONS
	belongs_to :user
	belongs_to :account
	belongs_to :role

  #CONSTANTS
  ROLES = %w[owner member visitor]

  #SCOPES
end
