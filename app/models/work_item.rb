class WorkItem < ActiveRecord::Base
  include Slug

  #ACCESSORS
  # attr_accessible :title, :body

  #PERMALINK GENERATION
  slug_for_field :name

	#ASSOCIATIONS
	belongs_to :priority
	belongs_to :step
	belongs_to :work_type
	has_many :tasks, :dependent => :destroy

  #VALIDATORS
  validates :name, :presence => true
  validates :slug, :presence => true, :uniqueness => true, :format => {:with => /^[A-Za-z0-9\-_ ]+$/, :message => "is invalid"}

  #METHODS

end
