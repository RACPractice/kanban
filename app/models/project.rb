class Project < ActiveRecord::Base
  include Slug

  #ACCESSORS
  attr_accessible :name, :description, :account_id, :visible

  #PERMALINK GENERATION
  slug_for_field :name

  #VALIDATORS
  validates :name, :slug, :account_id, :presence => true
  validates :slug, :uniqueness => true, :format => {:with => /^[A-Za-z0-9\-_ ]+$/, :message => "is invalid"}

  #ASSOCIATIONS
  has_and_belongs_to_many :steps
  belongs_to :account

  #CALLBACKS

  #SCOPES
  # Return all projects owned by account
  scope :all_where_account, lambda{ |account| { :conditions => { :account_id => account.to_i } } }


end
