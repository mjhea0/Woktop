class SessionsController < ApplicationController
  def new
  end
  
  def create
    @errors = false
    user = User.find_by_email(params[:email])
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to profile_url
    else
      @errors = true
      render 'new'
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
