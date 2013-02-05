class Member < ActiveRecord::Base
  # DEPRECATED CLASS, only kept around for migrations to work properly.

  #ACCESSORS
  attr_accessible :user_id, :account_id, :role_id, :invite_sent, :account, :role

	#ASSOCIATIONS
	belongs_to :user
	belongs_to :account
	belongs_to :role

  #SCOPES
end
