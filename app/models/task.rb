class Task < ActiveRecord::Base
  include Slug
  #ACCESSORS
  attr_accessible :name, :description, :work_item_id

  #PERMALINK GENERATION
  slug_for_field :name

  #VALIDATORS
  validates :name, :work_item_id, :presence => true
  validates :slug, :presence => true, :uniqueness => true, :format => {:with => /^[A-Za-z0-9\-_ ]+$/, :message => "is invalid"}

	#ASSOCIATIONS
	belongs_to :work_item

  #METHODS

end
