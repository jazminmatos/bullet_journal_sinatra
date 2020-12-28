class EntryAppController < ApplicationController
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
      redirect "/entries/#{@entry.id}" #doesn't work with single quotes
    else
      redirect '/entries/new' ###add error message?
    end
  end

  #loads individual entry pages
  #inaccessible if logged out
  get '/entries/:id' do
    if logged_in?
      #need access to user & entry in the view file
      @user = current_user
      @entry = Entry.find_by_id(params[:id])
      erb :'/entries/show_entry'
    else
      redirect '/login'
    end
  end
end