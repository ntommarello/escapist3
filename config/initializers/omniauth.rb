# config/initializers/omniauth.rb
FACEBOOK_APP_ID = '176765569051964'
FACEBOOK_SECRET = '8f9278cf3011921ff6607df3bcb67080'
TWITTER_KEY = "IrRVxDLTvl7x4S1y3noA"
TWITTER_SECRET = "NQTxK6crqRByfa4thQl6Z7jaOdlE7JuRFZK6iQWFg"
BITLY_ID = "ntommarello"
BITLY_KEY = "R_ce1c0b8cf328161bd22d3e28f1c7dd09"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, TWITTER_KEY, TWITTER_SECRET
  provider :facebook, FACEBOOK_APP_ID, FACEBOOK_SECRET
end