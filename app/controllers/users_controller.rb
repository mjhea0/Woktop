class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(session[:user_id])
    @dropbox_users = @user.dropbox_users
    
    dropboxSession = DropboxSession.new(APP_KEY, APP_SECRET)

    dropboxSession.get_request_token

    @auth_url = dropboxSession.get_authorize_url url_for(dropboxAuth_url)
    session[:dropbox_session] = dropboxSession.serialize
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to Woktop!"
      redirect_to profile_url
    else
      flash.now[:error] = "Hmm, there were some errors..."
      render 'new'
    end
  end
  
  def edit
    @user = User.find(session[:user_id])
  end
  
  def update
    @user = User.find(session[:user_id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to profile_url
    else
      flash.now[:error] = "Hmm, there were some errors..."
      render 'edit'
    end
  end
end