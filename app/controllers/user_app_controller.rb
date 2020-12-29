class UserAppController < ApplicationController
  #loads the signup page
  #should not have access if already logged in
  get '/signup' do
    if logged_in?
      redirect '/entries'
    else
      erb :'/users/signup'
    end
  end

  #receives user input from signup form
  #params => {"username"=>"Jaz", "email"=>"jaz@gmail.com", "password"=>"pw"}
  post '/signup' do
    #create new instance of user
    @user = User.new(params)
    
    #Save to database -- will not save if there's no pw
    #Make sure they inputted all 3 fields
    if @user.save && @user.username != "" && @user.email != ""
      #Log them in by setting session hash --> then redirect to entries
      session[:user_id] = @user.id #now has an id b/c it saved

      redirect '/entries'
    else
      redirect '/signup'
    end
  end

  #loads the login page
  #should not have access if already logged in
  get '/login' do
    if logged_in?
      redirect '/entries'
    else
      erb :'/users/login'
    end
  end

  #receives user input from login form
  #finds the user using username
  #if user exists and the salted & hashed pw matches the one in the db, logs in user
  post '/login' do
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/entries'
    else
      redirect '/login'
    end
  end

  #clear session hash to logout user
  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/'
    end
  end
end