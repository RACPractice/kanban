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

end
