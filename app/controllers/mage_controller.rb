# Note: You shouldn't need to update anything in this file
# Config is locates in /settings/development.yml
require 'oauth'
require 'benchmark'
class MageController < ApplicationController

  REQUEST_TOKEN_PATH = '/oauth/initiate'
  AUTHORIZATION_PATH = '/admin/oauth_authorize'
  ACCESS_TOKEN_PATH = '/oauth/token'
  # Other constants
  NUM_ITERATIONS = 50

  # Step 1: Get request token from magento.
  # We are passing the callback so that magento knows where to redirect user after authorization.
  def oauth_request_token
    request_token = consumer.get_request_token(:oauth_callback => Settings.magento.oauth_callback)
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret

    # Step 2: Once magento verifies the request token successfully, it will return an authorization url
    # which we need to redirect the user to
    redirect_to request_token.authorize_url
  end

  # Step 3: Authorization is complete, now we should be able to get an access token and use the REST API
  # Note that this method (action) is bound to the callback url. Once the user authorizes the application,
  # this action will get fired.
  def oauth_callback
    request_token = OAuth::RequestToken.new(consumer, session[:request_token], session[:request_token_secret])
    access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    # Don't store access token in session, this is only for a quick demo
    session[:access_token] = Marshal.dump(access_token)
    # Let's save the access token
    redirect_to :action => "make_rest_api_call"
  end

  # Step 4: The access token is set and we are ready to use the REST API
  def make_rest_api_call
    redirect_to :action => "oauth_request_token" and return unless session[:access_token]
    access_token = Marshal.load(session[:access_token])
    @products = access_token.get('/api/rest/products').body
  end

  # Optional: make a request to /mage/benchmark to benchmark the magento rest api
  # Precondition: Make sure access token is set
  def benchmark_rest_api
    @operation = '/api/rest/products'
    b_api = Benchmark.measure do
      (1..NUM_ITERATIONS).each do
        access_token = Marshal.load(session[:access_token])
        access_token.get(@operation).body
      end
    end
    @iterations = NUM_ITERATIONS
    @time = b_api.real
  end

  def consumer
    consumer = OAuth::Consumer.new(
      Settings.magento.consumer_key,
      Settings.magento.consumer_secret,
      :site               => Settings.magento.host,
      :request_token_path => REQUEST_TOKEN_PATH,
      :authorize_path     => AUTHORIZATION_PATH,
      :access_token_path  => ACCESS_TOKEN_PATH,
      :http_method => :get)
  end
end
