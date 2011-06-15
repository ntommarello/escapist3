# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Trek::Application.initialize!


APP_NAME = "Escapist"
APP_URL = "escapist.com"
APP_PEOPLE = "Escapists"
APP_CONTENT = "Challenges"
ASSETS_URL = "assets.stomp.io"

ActionMailer::Base.default_url_options = { :host => APP_URL }