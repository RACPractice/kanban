class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

  #ACCESSORS
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :login, :full_name
  attr_accessor :login
  attr_accessible :avatar
  has_attached_file :avatar, :styles => { :medium => "140x140>", :thumb => "30x30>" }

	#ASSOCIATIONS
  has_many :memberships
	has_many :accounts, :foreign_key => 'owner_id'
  has_many :projects, :through => :memberships

  after_create :create_default_account, :welcome_message

	#accepts_nested_attributes_for :accounts, :reject_if => proc {|a|	a['name'].blank? }, :allow_destroy => true

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

  # Returns a scope of all the users that are NOT members
  # of the given project
  def self.not_members_of(project)
    where("id NOT IN (?)", project.memberships.map(&:user_id).uniq)
  end

  def avatar_src
    return @avatar_src if @avatar_src
    if avatar_file_name
      @avatar_src = avatar.url(:thumb)
    else
      @avatar_src = '/assets/default_user_icon_128.png'
    end
    @avatar_src
  end

  def membership_id
    nil
  end

  def create_default_account
    Account.create name: 'Default account', description: 'My first account', owner: self
  end

  def welcome_message
    UserMailer.welcome_message(self).deliver
  end
end
