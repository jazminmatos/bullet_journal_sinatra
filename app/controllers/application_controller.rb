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
      redirect '/signup' ###add an error message???
    end
    
    #If can't log them in, redirect to signup (error message pop up?)
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
      redirect '/login' ###add an error message?
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

  # display a user's entries
  # This will be replaced by '/entries/entries.erb'
  # get '/users/:username' do
  #   binding.pry
  #   @user = User.find_by(username: params[:username])
  #   erb :'/users/show'
  # end

  #displays a user's entries
  #user should be logged in
  get '/entries' do
    if logged_in?
      #in order to access user and entries in view file
      @user = current_user
      @entries = Entry.all

      erb :'/entries/entries'
    else
      redirect '/login' ###add error message?
    end
  end

  #loads the create entries form
  get '/entries/new' do
    if logged_in?
      erb :'/entries/new'
    else
      redirect '/login' ###add error message?
    end
  end

  #receives user input from create from
  #params => {"date" => "", "goal" => "", "log" => "", "gratitude" => ""}
  #fields can't be empty
  post '/entries' do
    ###is 'logged_in? necessary if you can't access this page if you're logged out due to get request?
    if logged_in? && !params[:goal].empty? && !params[:log].empty? && !params[:gratitude].empty?
      #binding.pry
      @entry = Entry.create(params)
      redirect '/entries/#{@entry.id}'
    else
      redirect '/entries/new' ###add error message?
    end
  end

  get '/entries/:id' do
    if logged_in?
      @user = current_user
      @entry = Entry.find_by_id(params[:id])
      erb :'/entries/show_entry'
    else
      redirect '/login'
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
