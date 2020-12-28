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
      #in order to access user in view file
      @user = current_user

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
    if logged_in? && !params[:date].empty? && !params[:goal].empty? && !params[:log].empty? && !params[:gratitude].empty?
      #binding.pry
      @entry = Entry.create(date: params[:date], goal: params[:goal], log: params[:log], gratitude: params[:gratitude], user_id: current_user.id)
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

  #loads edit form
  #make sure they're logged in
  #make sure correct user is accessing this
  #find entry using id
  get '/entries/:id/edit' do
    @entry = Entry.find_by_id(params[:id])
    if logged_in? && @entry.user == current_user
        erb :'/entries/edit_entry'
    else
        redirect '/login'
    end
  end

  #update all fields & save
  #Make sure all fields are filled out (no blanks)
  patch '/entries/:id' do
    @entry = Entry.find_by_id(params[:id])
    if !params[:date].empty? && !params[:goal].empty? && !params[:log].empty? && !params[:gratitude].empty?
        @entry.update(date: params[:date], goal: params[:goal], log: params[:log], gratitude: params[:gratitude])
        @entry.save
        redirect "/entries/#{@entry.id}"
    else
        redirect "/entries/#{@entry.id}/edit"
    end
  end

  #deletes entries
  #find entry by its id
  #make sure another user can't delete it
  delete '/entries/:id' do
    @entry = Entry.find_by_id(params[:id])
    if @entry.user_id == current_user.id
        @entry.delete
        redirect '/entries'
    else
        redirect "/entries/#{@entry.id}"
    end
  end
end