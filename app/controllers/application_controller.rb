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

  #receives user input from signup form
  #params => {"username"=>"Jaz", "email"=>"jaz@gmail.com", "password"=>"pw"}
  post '/signup' do
    #binding.pry

    #create new instance of user
    @user = User.new(params)
    
    #Save to database -- will not save if there's no pw
    #Make sure they inputted all 3 fields
    if @user.save && @user.username != "" && @user.email != ""
      #Log them in by setting session hash --> then redirect to entries
      session[:user_id] = @user.id #now has an id b/c it saved

      ###redirect to list of journal entries
    else
      redirect '/signup'
    end
    
    #If can't log them in, redirect to signup (error message pop up?)
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
