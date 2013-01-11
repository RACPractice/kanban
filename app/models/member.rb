class Member < ActiveRecord::Base

  #ACCESSORS
  attr_accessible :user_id, :account_id, :role_id, :invite_sent, :member, :owner

	#ASSOCIATIONS
	belongs_to :user
	belongs_to :account
	belongs_to :role

  #CONSTANTS
  ROLES = %w[owner member visitor]

  #SCOPES
  def self.with_role role
    where("roles_mask & ?", ([role.to_s] & ROLES).map {|r| 2**ROLES.index(r)}.sum)
  end

  def self.with_roles roles
    where("roles_mask & ?", (roles.collect{|x| x.to_s} & ROLES).map {|r| 2**ROLES.index(r)}.sum)
  end

  def roles=(roles)
    self.update_attribute(:roles_mask, (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end
end
