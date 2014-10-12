# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
QMoney::Application.initialize!

#Logger
if Rails.env.development?
  Rails.logger = Le.new('1abee0b2-24ed-4409-9c17-7ac7cc5c4911', debug: true)
else
  Rails.logger = Le.new('7d108f72-cfb5-4436-ac42-a1c78c2b4069')
end
