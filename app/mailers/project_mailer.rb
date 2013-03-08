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

  def notify_step_changed_for_work_item work_item, new_step_id, current_user
    @user = current_user
    @new_step = Step.find new_step_id
    @recipients = work_item.users.collect(&:email)
    @work_item = work_item
    @project = work_item.step.projects.first
    @project_url = account_project_url(@project.account, @project)
    mail(to: @recipients, subject: "[#{@project.name}] Work item #{work_item.name} has been changed from step '#{work_item.step.name}' to step '#{@new_step.name}'")
  end

  def notify_step_created step, current_user
    @current_user = current_user
    @step = step
    @project = step.projects.first
    @recipients = @project.users.collect(&:email)
    @project_url = account_project_url(@project.account, @project)
    mail(to: @recipients, subject: "[#{@project.name}] New step named '#{@step.name}' has been created by #{@current_user.username}")
  end

  def notify_step_deleted step_name, project, current_user
    @current_user = current_user
    @step_name = step_name
    @project = project
    @recipients = @project.users.collect(&:email)
    @project_url = account_project_url(@project.account, @project)
    mail(to: @recipients, subject: "[#{@project.name}] Step named '#{@step_name}' has been deleted by #{@current_user.username}")
  end
end
