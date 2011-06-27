# config/initializers/omniauth.rb


Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, nil, nil, :setup => true
  provider :facebook, nil, nil, :setup => true
end