class Ability
  include CanCan::Ability

  def initialize(user)
    user.memberships.each do |membership|
      if membership.role.name == "owner"
        can :manage, membership.project
        can :manage, membership.project.account
      elsif membership.role.name == "member"
        can :manage, membership.project
      else
        can :read, membership.project
      end
    end
  end
end
