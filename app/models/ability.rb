class Ability
  include CanCan::Ability

  def initialize(user)
		if user.role? :owner
			can :manage, :all
		elsif user.role? :member
			can :manage, WorkItem
		else
			can :read, :all
		end
  end
end
