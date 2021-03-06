class WorkType < ActiveRecord::Base
  include Slug
  #ACCESSORS
  attr_accessible :name

  #PERMALINK GENERATION
  slug_for_field :name

  #VALIDATORS
  validates :name, :presence => true, :uniqueness => true
  validates :slug, :presence => true, :uniqueness => true, :format => {:with => /^[A-Za-z0-9\-_ ]+$/, :message => "is invalid"}

end
