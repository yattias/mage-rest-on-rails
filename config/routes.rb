Rails.application.routes.draw do
  get '/mage/make_rest_api_call', to: 'mage#make_rest_api_call'
  # You should not have to hit the following routes manually, but you can
  # for debugging purposes
  get '/mage/oauth_request_token', to: 'mage#oauth_request_token'
  get '/mage/oauth_callback', to: 'mage#oauth_callback'
  get '/mage/benchmark', to: 'mage#benchmark_rest_api'
end
