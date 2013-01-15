class Step < ActiveRecord::Base
  include Slug

  #ACCESSORS
	attr_accessible :name, :anchor, :capacity, :position

  #PERMALINK GENERATION
  slug_for_field :name

  #VALIDATORS
  validates :name, :presence => true
  validates :slug, :presence => true, :format => {:with => /^[A-Za-z0-9\-_ ]+$/, :message => "is invalid"}

  #ASSOCIATIONS
  has_and_belongs_to_many :projects
  has_many :work_items

  #METHODS

end
