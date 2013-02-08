class MembershipsController < ApplicationController

	before_filter :authenticate_user!

  def index
    @project = current_user.projects.where('project_id = ?', params[:project_id]).first
    @memberships = @project.memberships
    respond_to do |format|
      format.json do
        render :json => {memberships: @memberships.collect{|m| {id: m.id,
                                                   user_id: m.user_id,
                                                   username: m.user.username,
                                                   role_name: m.role.name}},
                         non_members: User.not_members_of(@project).map(&:username) }
      end
    end
  end

  def create
    project = current_user.projects.where('project_id = ?', params[:project_id]).first
    role = Role.find_by_name("member")
    user = User.find_by_username(params[:membership][:username])
    if user
      m = project.memberships.create role: role, user: user
      respond_to do |format|
        format.json do
          render :json => {id: m.id, user_id: m.user_id, username: m.user.username, role_name: m.role.name}
        end
      end
    else
      respond_to do |format|
        format.json { render json: "That user does not exist", status: :unprocessable_entity }
      end
    end
  end

end
