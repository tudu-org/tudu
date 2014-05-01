# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Tudu::Application.initialize!

Time::DATE_FORMATS[:custom_time] = "%_m/%-d/%y, %I:%M %p"