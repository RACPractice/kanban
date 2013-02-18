class UserMailer < ActionMailer::Base
  default from: "Kanban ness<kanban@ness.com>"
  layout 'layouts/mail'

  def welcome_message user
  	@user = user
  	mail(to: @user.email, subject: "Welcome to Kanbanness")
  end
end
