require 'rubygems'
require 'oauth'
require 'json'

class WePay
  CONSUMER_KEY = "ccaa6f8e3885cf0691c2bf9000c281"
  SHARED_SECRET = "ed1ad7b35f"
  APIURL = "https://wepayapi.com"
  def initialize( _access_token )
    @access = _access_token
  end

  def get path
    if !/^\/v1\//.match(path)
      path = "\/v1" + path
    end
    JSON.parse(@access.get(path).body)
  end
end