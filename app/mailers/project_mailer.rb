class ProjectMailer < ActionMailer::Base
  default from: "Kanban ness<kanban@ness.com>"
  layout 'layouts/mail'

  def notify_work_item_assigned work_item, user
  	@user = user
  	@work_item = work_item
  	project = work_item.step.projects.first
  	account = project.account
  	@project_url = account_project_url(account, project)
  	@project_name = project.name
  	mail(to: @user.email, subject: "You have been assigned to work item: #{work_item.name}")
  end

  def informed_assigned_to_project project, user
  	@user = user
  	@project = project
  	@project_url = account_project_url(project.account, project)
  	mail(to: @user.email, subject: "You have been registered to work on project: #{project.name}")
  end
end
