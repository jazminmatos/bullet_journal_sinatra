require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "shhh_its_a_secret"
  end

  #loads the homepage
  get '/' do
    erb :index
  end

  #loads the signup page
  ###should not have access if already logged in
  get '/signup' do
    erb :'/users/signup'
  end

  post '/signup' do
  end

  #loads the login page
  ###should not have access if already logged in
  get '/login' do
    erb :'/users/login'
  end

  #finds the user using username
  #if user exists and the salted & hashed pw matches the one in the db, logs in user
  post '/login' do
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      ###redirect to list of journal entries
    end
  end

  helpers do
    #finds the current_user
    def current_user
      User.find(session[:user_id])
    end

    #checks the boolean value of session to confirm whether or not a user is logged in
    def logged_in?
      !!session[:user_id]
    end
  end
end
