require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "shhh_its_a_secret"
  end

  #loads the homepage
  get "/" do
    erb :index
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
