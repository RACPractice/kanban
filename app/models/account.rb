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
	belongs_to :owner, :class_name => User
	has_many :projects, :dependent => :destroy

  # Load all available accounts for specified user
  # * *Args*    :
  #   - +user+ -> user to search accounts for
  # * *Returns* :
  #   - all available accounts for this user
  def self.all_available(user)
    where("owner_id = ?", user.id)
  end
end
