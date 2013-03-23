class SessionsController < ApplicationController
  def new
  end
  
  def create
    @errors = false
    user = User.find_by_email(params[:email])
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome back!"
      redirect_to profile_url
    else
      @errors = true
      flash.now[:error] = "Hmm, there were some errors..."
      render 'new'
    end
  end
  
  def destroy
    session[:user_id] = nil
    flash[:success] = "Goodbye!"
    redirect_to root_url
  end
end
