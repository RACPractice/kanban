class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :accounts_attributes
  # attr_accessible :title, :body

	# relationship
	has_many :members
	has_many :accounts, :through => :members

	#accepts_nested_attributes_for :accounts

	accepts_nested_attributes_for :accounts, :reject_if => proc {|a|	a['name'].blank? }, :allow_destroy => true

end
