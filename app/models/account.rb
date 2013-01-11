class Account < ActiveRecord::Base
	include Slug
	#after_create :create_role_with_default_role

	#ACCESSORS
	attr_accessible :name, :slug, :description

	#PERMALINK GENERATION
  slug_for_field :name

  #VALIDATORS
  validates :name, :presence => true, :uniqueness => true
  validates :slug, :presence => true, :uniqueness => true, :format => {:with => /^[A-Za-z0-9\-_ ]+$/, :message => "is invalid"}

  #ASSOCIATIONS
	has_many :members
	has_many :users, :through => :members
	has_many :roles, :through => :members
	has_many :projects, :dependent => :destroy

	#METHODS
  # Return all accounts owned by specified user
  # * *Params* :
  #   -+user+ - owner of the accounts
  # * *Returns* :
  #   - the Arel query for the accounts
  def self.all_where_owner user
    all_where_role(user, 'owner')
  end

  # Return all accounts where specified user is a member
  # * *Params* :
  #   -+user+ - member of the accounts
  # * *Returns* :
  #   - the Arel query for the accounts
  def self.all_where_member user
    all_where_role(user, 'member')
  end

  # Return members accounts by this user
  # * *Params* :
  #   -+user+ - visitor of the accounts
  # * *Returns* :
  #   - the Arel query for visitor accounts
  def self.all_where_visitor user
    all_where_role(user, 'visitor')
  end

  # Return all accounts by this user with specified role
  # * *Params* :
  #   -+user+ - member of the accounts
  #   -+role+ - role for the user
  # * *Returns* :
  #   - the Arel query for accounts
  def self.all_where_role(user, role)
    joins(:users, :roles).where("users.id = ?", user.id).where("roles.name = ?", role)
  end
end
