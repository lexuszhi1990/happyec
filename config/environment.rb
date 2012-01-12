# Load the rails application
require File.expand_path('../application', __FILE__)
Pry.editor = "vim"
# Initialize the rails application
Ec::Application.initialize!
