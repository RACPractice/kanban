class Ability
  include CanCan::Ability

  def initialize(user)
    user.members.each do |membership|
      if membership.role.name == "owner"
        can :manage, membership.account
        can :manage, membership.account.projects
      elsif membership.role.name == "member"
        can :manage, membership.account.projects
      else
        can :read, membership.account.projects
      end
    end
  end
end



