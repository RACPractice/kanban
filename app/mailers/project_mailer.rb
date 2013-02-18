class ProjectMailer < ActionMailer::Base
  default from: "kanban@ness.com"
  layout 'layouts/mail'

  def notify_work_item_assigned work_item, user
  	@user = user
  	@work_item = work_item
  	mail(to: @user.email, subject: "You have been assigned to work item: #{work_item.name}")
  end
end
