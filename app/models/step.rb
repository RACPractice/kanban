class Step < ActiveRecord::Base
  include Slug

  CATEGORIES = %w(backlog custom archive)

  #ACCESSORS
	attr_accessible :name, :anchor, :capacity, :position, :removable, :category

  #PERMALINK GENERATION
  slug_for_field :name

  #VALIDATORS
  validates :name, :slug, :capacity, :category, :presence => true
  validates :category, :inclusion => {:in => CATEGORIES}
  validates :slug, :format => {:with => /^[A-Za-z0-9\-_ ]+$/, :message => "is invalid"}

  #ASSOCIATIONS
  has_and_belongs_to_many :projects
  has_many :work_items

  #METHODS

end
