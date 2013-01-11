source 'https://rubygems.org'

gem 'rails', '3.2.11'

# gem 'mysql2', '~> 0.3.11'
gem 'pg'
gem 'devise'
gem 'thin'
gem 'jquery-rails'
gem 'haml-rails'
gem 'ejs'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails'
end

group :development do
	gem 'debugger'
end

group :test, :development do
  gem "rspec-rails", "~> 2.0"
  gem 'railroady'
end

group :test do
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'capybara'
  #THIS has to be added for using webkit - a faster engine than selenium
  #gem "capybara-webkit"
end
