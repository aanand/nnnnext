require "omniauth"
require "omniauth-twitter"

module Nnnnext
  set :views, root + "views"

  use OmniAuth::Strategies::Twitter,
    omniauth[:consumer_key],
    omniauth[:consumer_secret]

  use Rack::Session::Cookie,
    secret: session_secret,
    expire_after: 60*60*24*30
end
