# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Kanban::Application.initialize!


# Configuration for using SendGrid on Heroku
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :user_name => "app10836433@heroku.com",
  :password => "j7ym1fsc",
  :domain => "still-woodland-8687.herokuapp.com",
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
