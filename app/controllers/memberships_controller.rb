class MembershipsController < ApplicationController

	before_filter :authenticate_user!

  include ProjectsHelper

  def index
    @project = current_user.projects.where('project_id = ?', params[:project_id]).first
    @memberships = @project.memberships
    respond_to do |format|
      format.json do
        render :json => {memberships: @memberships.collect{|m| {id: m.id,
                                                   user_id: m.user_id,
                                                   username: m.user.username,
                                                   role_name: m.role.name,
                                                   avatar_src: thumb_avatar_src(m)}},
                         non_members: User.not_members_of(@project).map(&:username) }
      end
    end
  end

  def create
    project = current_user.projects.where('project_id = ?', params[:project_id]).first
    role = Role.find_by_name("member")
    user = User.find_by_username(params[:membership][:username])
    if user
      userAlreadyAssigned = Membership.joins(:user, :project).where('projects.id = ?', project.id).where('users.id = ?', user.id).count > 0
      if userAlreadyAssigned
        render json: "User #{user.username} is already assigned to this project", status: :unprocessable_entity
      else
        m = project.memberships.create role: role, user: user
        ProjectMailer.informed_assigned_to_project(project, user).deliver
        render :json => {id: m.id, user_id: m.user_id, username: m.user.username, role_name: m.role.name, avatar_src: thumb_avatar_src(m)}
      end
    else
      render json: "That user does not exist", status: :unprocessable_entity
    end
  end
end
