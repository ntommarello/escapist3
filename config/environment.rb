# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Trek::Application.initialize!
Trek::Application.configure do
config.gem "jammit"
end

APP_NAME = "Escapist"
APP_URL = "escapist.me"
APP_PEOPLE = "Escapists"
APP_CONTENT = "Challenges"
ASSETS_URL = "assets.stomp.io"
TWITTER_NAME = "escapist_me"

FACEBOOK_APP_ID = '176765569051964'
FACEBOOK_SECRET = '8f9278cf3011921ff6607df3bcb67080'
TWITTER_KEY = "IrRVxDLTvl7x4S1y3noA"
TWITTER_SECRET = "NQTxK6crqRByfa4thQl6Z7jaOdlE7JuRFZK6iQWFg"
BITLY_ID = "ntommarello"
BITLY_KEY = "R_ce1c0b8cf328161bd22d3e28f1c7dd09"



ActionMailer::Base.default_url_options = { :host => APP_URL }