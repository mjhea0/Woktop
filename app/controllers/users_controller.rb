class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(session[:user_id])
    @dropbox_users = @user.dropbox_users
    
    dropboxSession = DropboxSession.new(APP_KEY, APP_SECRET)

    binding.pry

    dropboxSession.get_request_token

    #Grayson, this auth_url is visible on the profile only... but if the user is signed in and they navigate away from the profile, then they can't see it, can we make this global to any signed in user?
    @dropbox_auth_url = dropboxSession.get_authorize_url url_for(dropboxAuth_url)
    session[:dropbox_session] = dropboxSession.serialize
  end
  
  def create
    @errors = false


    @user = User.new
    @user.email = params[:email]
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]

    binding.pry

    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to Woktop!"
      redirect_to profile_url
    else
      @errors = true
      flash.now[:alert] = "Hmm, there were some errors..."
      render 'new'
    end
  end
  
  def edit
    @user = User.find(session[:user_id])
  end
  
  def update
    @errors = false
    @user = User.find(session[:user_id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to profile_url
    else
      @errors = true
      flash.now[:alert] = "Hmm, there were some errors..."
      render 'edit'
    end
  end
end