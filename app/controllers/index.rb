require 'omniauth-twitter'
require 'twitter'



get '/' do
  # Look in app/views/index.erb
  erb :index
end

post '/tweets' do
  # Look in app/views/index.erb
  # puts params
  user = User.find_by_nickname(session[:admin])

  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = "" #YOUR CONSUMER KEY
    config.consumer_secret     = "" #YOUR CONSUMER KEY SECRET
    config.access_token        = user.access_token
    config.access_token_secret = user.access_token_secret
  end

  client.update(params[:tweet])
  erb :result, layout: false
end

use OmniAuth::Builder do
  provider :twitter, 'YOUR CONSUMER KEY', '#YOUR CONSUMER KEY SECRET'
end

configure do
  enable :sessions
end

helpers do
  def admin?
    session[:admin]
  end
end

get '/public' do
  "This is the public page - everybody is welcome!"
end

get '/private' do
  halt(401,'Not Authorized') unless admin?
  "This is the private page - members only"
end

get '/login' do
  session[:admin] = true

  redirect to("/auth/twitter")
end

get '/logout' do
  session[:admin] = nil
  "You are now logged out"
end

get '/auth/twitter/callback' do
  env['omniauth.auth'] ? session[:admin] = true : halt(401,'Not Authorized')
  "You are now logged in"
  p env['omniauth.auth']
  @user = User.find_or_create(env['omniauth.auth'])
  session[:admin] = @user.nickname
  redirect '/'
end

get '/auth/failure' do
  params[:message]
end
