class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :accounts_attributes, :login
  attr_accessor :login

	# relationship
	has_many :members
	has_many :accounts, :through => :members

	accepts_nested_attributes_for :accounts, :reject_if => proc {|a|	a['name'].blank? }, :allow_destroy => true

  # Overrides devise method to be able to login with username or email
  # * *Args*    :
  #   - +login_conditions+ -> the login conditions
  # * *Returns* :
  #   - the Arel coditions to find the user
  def self.find_first_by_auth_conditions(login_conditions)
    conditions = login_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", {value: login.downcase}]).first
    else
      where(conditions).first
    end
  end
end
