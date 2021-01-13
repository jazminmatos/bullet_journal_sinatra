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

  helpers do
    #finds the current_user by searching for their session hash
    def current_user
      User.find(session[:user_id])
    end

    #checks the boolean value of session hash to confirm whether or not a user is logged in
    def logged_in?
      !!session[:user_id]
    end

    #redirect if not logged in
    def redirect_if_not_logged_in
      if !logged_in?
        redirect '/login'
      end
    end

    def redirect_if_not_authorized(record, path)
      if current_user != record.user
        redirect path
      end
    end
  end
end
