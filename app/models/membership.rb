class Membership < ActiveRecord::Base

  #ACCESSORS
  attr_accessible :user_id, :project_id, :role_id, :invite_sent, :project, :role

	#ASSOCIATIONS
	belongs_to :user
	belongs_to :project
	belongs_to :role

  #SCOPES
end
