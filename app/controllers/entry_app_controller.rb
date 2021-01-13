class EntryAppController < ApplicationController
  #displays a user's entries
  #user should be logged in
  get '/entries' do
    redirect_if_not_logged_in
    #in order to access entries in view file
    @entries = current_user.entries
    erb :'/entries/entries'
  end

  #loads the create entries form
  get '/entries/new' do
    redirect_if_not_logged_in
    erb :'/entries/new'
  end

  #receives user input from create from
  #params => {"date" => "", "goal" => "", "log" => "", "gratitude" => ""}
  #fields can't be empty
  post '/entries' do
      @entry = current_user.entries.new(params)
      if @entry.save #checking if Entry validation goes through
        redirect "/entries/#{@entry.id}" #doesn't work with single quotes
      else
        redirect '/entries/new'
      end
  end

  #loads individual entry pages
  #inaccessible if logged out
  #inaccessible if incorrect user
  get '/entries/:id' do
    @entry = Entry.find_by_id(params[:id])
    redirect_if_not_authorized(@entry, '/entries')
    erb :'/entries/show_entry'
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