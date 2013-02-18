class HomeController < ApplicationController

	before_filter :authenticate_user!

  def index
    @accounts = current_user.accounts
    owner_role = Role.owner.first
    member_role = Role.member.first
    @owning_projects = Project.joins(:memberships).where('memberships.role_id = ?', owner_role.id).where('memberships.user_id = ?', current_user.id)
    @member_projects = Project.joins(:memberships).where('memberships.role_id = ?', member_role.id).where('memberships.user_id = ?', current_user.id)
  end
end
