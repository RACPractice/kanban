class Task < ActiveRecord::Base
  #ACCESSORS
  attr_accessible :name, :done, :work_item_id, :blocked

  #VALIDATORS
  validates :name, :work_item_id, :presence => true

  #ASSOCIATIONS
  belongs_to :work_item

  #METHODS
  default_scope order('created_at ASC')

end
