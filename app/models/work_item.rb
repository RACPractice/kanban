class WorkItem < ActiveRecord::Base
  include Slug

  #ACCESSORS
  attr_accessible :name, :slug, :description, :project_id, :work_type_id, :priority_id, :step_id,
									:work_value, :is_ready, :is_blocked, :assigned_to, :target_date

  #PERMALINK GENERATION
  slug_for_field :name

	#ASSOCIATIONS
	belongs_to :priority
	belongs_to :step
	belongs_to :work_type
	has_many :tasks, :dependent => :destroy
  has_and_belongs_to_many :users

  #VALIDATORS
  validates :name, :step, :work_value, :presence => true
  validates :work_value, :inclusion => 0..3
  validates :slug, :presence => true, :uniqueness => true, :format => {:with => /^[A-Za-z0-9\-_ ]+$/, :message => "is invalid"}

  #UTILS
  acts_as_taggable_on :labels
  #METHODS

end
